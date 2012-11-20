Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2KTPvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:51:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42480 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751953Ab2KTPvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:51:16 -0500
Message-ID: <1353426677.11235.15.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: consolidate if (foo) bar(foo) checks and
 add debugfs_remove
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Constantine Shulyupin <const@makelinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 20 Nov 2012 07:51:17 -0800
In-Reply-To: <20121120153751.GJ7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	 <20121120142906.GD7955@dm> <1353422629.11235.10.camel@joe-AO722>
	 <20121120144742.GG7955@dm>
	 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
	 <1353423503.11235.12.camel@joe-AO722> <20121120153751.GJ7955@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 15:37 +0000, Andy Whitcroft wrote:
> Consolidate the if (foo) bar(foo) detectors into a single check.  Add
> debugfs_remove and family.
> 
> Based on a patch by Constantine Shulyupin <const@MakeLinux.com>.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
>  
> +# check for needless "if (<foo>) fn(<foo>)" uses
> +		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
> +			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
> +
[]
> +# check for needless debugfs_remove() and debugfs_remove_recursive*() checks

Hey Andy, that's an incomplete comment.
Just remove it.

> +			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
> +				WARN('NEEDLESS_IF',
> +				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}
>  		}
>  



