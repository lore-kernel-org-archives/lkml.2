Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2KHRrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:47:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2KHRrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:47:07 -0500
Date: Thu, 8 Nov 2012 17:47:02 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/5] checkpatch: Remove reference to
 feature-removal-schedule.txt.
Message-ID: <20121108174702.GL3066@dm>
References: <1352382402-2706-1-git-send-email-tm@tao.ma>
 <1352382635-2773-1-git-send-email-tm@tao.ma>
 <1352382635-2773-3-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352382635-2773-3-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 09:50:33PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
> but there is still some reference to this file. So remove them.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  scripts/checkpatch.pl |   44 --------------------------------------------
>  1 files changed, 0 insertions(+), 44 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 21a9f5d..b0240b8 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -352,27 +352,6 @@ sub deparenthesize {
>  
>  $chk_signoff = 0 if ($file);
>  
> -my @dep_includes = ();
> -my @dep_functions = ();
> -my $removal = "Documentation/feature-removal-schedule.txt";
> -if ($tree && -f "$root/$removal") {
> -	open(my $REMOVE, '<', "$root/$removal") ||
> -				die "$P: $removal: open failed - $!\n";
> -	while (<$REMOVE>) {
> -		if (/^Check:\s+(.*\S)/) {
> -			for my $entry (split(/[, ]+/, $1)) {
> -				if ($entry =~ m@include/(.*)@) {
> -					push(@dep_includes, $1);
> -
> -				} elsif ($entry !~ m@/@) {
> -					push(@dep_functions, $entry);
> -				}
> -			}
> -		}
> -	}
> -	close($REMOVE);
> -}
> -
>  my @rawlines = ();
>  my @lines = ();
>  my $vname;
> @@ -3181,29 +3160,6 @@ sub process {
>  			}
>  		}
>  
> -# don't include deprecated include files (uses RAW line)
> -		for my $inc (@dep_includes) {
> -			if ($rawline =~ m@^.\s*\#\s*include\s*\<$inc>@) {
> -				ERROR("DEPRECATED_INCLUDE",
> -				      "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
> -			}
> -		}
> -
> -# don't use deprecated functions
> -		for my $func (@dep_functions) {
> -			if ($line =~ /\b$func\b/) {
> -				ERROR("DEPRECATED_FUNCTION",
> -				      "Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
> -			}
> -		}
> -
> -# no volatiles please
> -		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
> -		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {
> -			WARN("VOLATILE",
> -			     "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
> -		}
> -

This last bit here looks to be an accidental extra deletiong ?  I don't
think this relates to the patch at hand.

>  # warn about #if 0
>  		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
>  			CHK("REDUNDANT_CODE",

-apw
