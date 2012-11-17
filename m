Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2KQNaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:30:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51924 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751102Ab2KQNaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:30:17 -0500
Message-ID: <1353159017.12430.21.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: debugfs_remove() can take NULL
From: Joe Perches <joe@perches.com>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>
Date: Sat, 17 Nov 2012 05:30:17 -0800
In-Reply-To: <1353155581-30852-1-git-send-email-const@MakeLinux.com>
References: <1353155581-30852-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-17 at 14:33 +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> debugfs_remove() can take a NULL, so let's check and warn about that.
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
>  scripts/checkpatch.pl |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f18750e..c062476 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3221,6 +3221,14 @@ sub process {
>  				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}
>  		}
> +# check for needless debugfs_remove() checks
> +		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> +			my $expr = $1;
> +			if ($line =~ /\bdebugfs_remove\(\Q$expr\E\);/) {
> +				WARN("NEEDLESS_DEBUGFS_REMOVE",
> +				     "debugfs_remove(NULL) is safe this check is probably not required\n" . $hereprev);
> +			}
> +		}
>  # check for needless usb_free_urb() checks
>  		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
>  			my $expr = $1;

Perhaps debugfs_remove_recursive should be added too.

Please create a consolidated block of tests for these
checks of:

	if (foo)
		something_with(foo)

and add kfree, usb_free_urb and your debugfs_remove (and
debugfs_remove_recursive?) to that block so that the
"if ($prevline..." test is done only once per patch line.



