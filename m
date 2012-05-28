Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2E1PPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:15:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40629 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2E1PPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:15:18 -0400
Message-ID: <4FC39683.5040600@boundarydevices.com>
Date: Mon, 28 May 2012 08:15:15 -0700
From: Eric Nelson <eric.nelson@boundarydevices.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH V3] checkpatch: check for whitespace before semicolon
 at EOL
References: <1338163246-6727-1-git-send-email-eric.nelson@boundarydevices.com> <20120528144259.GA5878@dm>
In-Reply-To: <20120528144259.GA5878@dm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 07:42 AM, Andy Whitcroft wrote:
> On Sun, May 27, 2012 at 05:00:46PM -0700, Eric Nelson wrote:
>> Requires --strict option during invocation:
>> 	~/linux$ scripts/checkpatch --strict foo.patch
>>
>> This tests for a bad habits of mine like this:
>>
>> 	return 0 ;
>>
>> Note that it does allow a special case of a bare semicolon
>> for empty loops:
>>
>> 	while (foo())
>> 		;
>>
>> Signed-off-by: Eric Nelson<eric.nelson@boundarydevices.com>
>> ---
>>   scripts/checkpatch.pl |    7 +++++++
>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index faea0ec..2262e1f 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -2448,6 +2448,13 @@ sub process {
>>   				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
>>   			}
>>   		}
>> +
>> +# check for whitespace before a non-naked semicolon
>> +		if ($line =~ /^\+.*\S\s+;/) {
>> +			CHK("SPACING",
>> +			    "space prohibited before semicolon\n" . $herecurr);
>> +		}
>> +
>
> Would this not also falsly trigger on 'for (foo = 10; foo; foo--) {' ?
>

No, because there's no space before any of the semicolons.

I ran this against the last 1500 commits in the kernel and the
only case I found which seemed questionable was a fragment
like this:
	for (foo=10; ; foo--) {

This points out that my commit message is wrong because it
doesn't only check at EOL (V1 did).

My testing also generated a large number of warnings like this for
patch 89812fc81f8d62d70433a8ff63d26819f372e8ec.

	CHECK: space prohibited before semicolon
	#2459: FILE: tools/perf/util/parse-events-flex.c:439:
	+    } ;

>>   # Check operator spacing.
>>   		if (!($line=~/\#\s*include/)) {
>>   			my $ops = qr{
>
> -apw
