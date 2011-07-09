Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1GIBI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 21:08:57 -0400
Received: from c60.cesmail.net ([216.154.195.49]:47963 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1GIBIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 21:08:54 -0400
Message-ID: <4E17AA24.1060405@gnu.org>
Date: Fri, 08 Jul 2011 21:08:52 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: suggest spaces around binary operators in
 strict mode
References: <20110708214159.7559.25740.stgit@mj.roinet.com> <1310166108.2042.6.camel@Joe-Laptop>
In-Reply-To: <1310166108.2042.6.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 07:01 PM, Joe Perches wrote:
> On Fri, 2011-07-08 at 17:41 -0400, Pavel Roskin wrote:
>> Signed-off-by: Pavel Roskin<proski@gnu.org>
>> ---
>>   scripts/checkpatch.pl |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index b0aa2c6..9431ada 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -2167,6 +2167,8 @@ sub process {
>>   					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
>>   						ERROR("need consistent spacing around '$op' $at\n" .
>>   							$hereptr);
>> +					} elsif ($ctx =~ /[^WCE]x[^WCE]/) {
>> +						CHK("spaces suggested around '$op' $at\n" . $hereptr);
>
> Hey Pavel.
>
> This should probably not be an elsif but
> a standalone test.

Maybe.  I just tried to minimize the changes.  I think all of the 
operators in the condition above the lines I changed need spaces around 
them, so I decided to reuse the code block.

Spaces around binary operands are pretty standard.  scripts/Lindent 
would add them.

I understand that not everybody wants that rule enforced, so I used a 
nicely worded warning and enabled it only in the strict mode.  That was 
done to avoid sparking a flamewar about formatting.

There are some cases when missing spaces are palatable, in particular 
with "|", which is thin.  So this may be OK:

(high_id << 8)|(low_id & 0xff)

But I've seen checkpatch ignore stuff like this:

ah->ah_gain.g_current-ah->ah_gain.g_f_corr

And that is just horrible on the eyes.  I want checkpatch to catch that.

> Also, there's an upcoming patch in mm that
> classifies all output ERROR/WARN/CHK types.
>
> This one should be "SPACING".

OK, please keep my suggestion in mind.

-- 
Regards,
Pavel Roskin
