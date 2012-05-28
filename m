Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2E1OnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:43:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48439 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2E1OnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:43:04 -0400
Date: Mon, 28 May 2012 15:42:59 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Eric Nelson <eric.nelson@boundarydevices.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH V3] checkpatch: check for whitespace before semicolon at
 EOL
Message-ID: <20120528144259.GA5878@dm>
References: <1338163246-6727-1-git-send-email-eric.nelson@boundarydevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338163246-6727-1-git-send-email-eric.nelson@boundarydevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 05:00:46PM -0700, Eric Nelson wrote:
> Requires --strict option during invocation:
> 	~/linux$ scripts/checkpatch --strict foo.patch
> 
> This tests for a bad habits of mine like this:
> 
> 	return 0 ;
> 
> Note that it does allow a special case of a bare semicolon
> for empty loops:
> 
> 	while (foo())
> 		;
> 
> Signed-off-by: Eric Nelson <eric.nelson@boundarydevices.com>
> ---
>  scripts/checkpatch.pl |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index faea0ec..2262e1f 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2448,6 +2448,13 @@ sub process {
>  				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
>  			}
>  		}
> +
> +# check for whitespace before a non-naked semicolon
> +		if ($line =~ /^\+.*\S\s+;/) {
> +			CHK("SPACING",
> +			    "space prohibited before semicolon\n" . $herecurr);
> +		}
> +

Would this not also falsly trigger on 'for (foo = 10; foo; foo--) {' ?

>  # Check operator spacing.
>  		if (!($line=~/\#\s*include/)) {
>  			my $ops = qr{

-apw
