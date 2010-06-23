Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0FWT23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:28:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab0FWT22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:28:28 -0400
Date: Wed, 23 Jun 2010 12:27:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Andy Whitcroft <apw@canonical.com>, Daniel Walker <dwalker@fifo99.com>,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts: checkpatch.pl
Message-Id: <20100623122759.7bf304e6.akpm@linux-foundation.org>
In-Reply-To: <1277286561-3448-2-git-send-email-lamiaposta71@gmail.com>
References: <1277286561-3448-1-git-send-email-lamiaposta71@gmail.com>
	<1277286561-3448-2-git-send-email-lamiaposta71@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 11:49:21 +0200
Raffaele Recalcati <lamiaposta71@gmail.com> wrote:

> From: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> 
> I've got a false positive when spaces are present
> at the beginning of a line.
> So I add this check, obviously outside comments.
> This patch is compatible with the actual mainline,
> I mean 7e27d6e778cd87b6f2415515d7127eba53fe5d02 commit.

I don't really understand that.  It would help if the changelog
were to include a copy of the code which triggers this "false
positive", and a copy of the incorrect checkpatch output.

Thanks.

> Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> ---
>  scripts/checkpatch.pl |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index a4d7434..315a827 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1433,6 +1433,13 @@ sub process {
>  			WARN("please, no space before tabs\n" . $herevet);
>  		}
>  
> +# check for spaces at the beginning of a line.
> +		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
> +			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
> +			WARN("please, no space for starting a line, \
> +				excluding comments\n" . $herevet);
> +		}
> +
>  # check we are in a valid C source file if not then ignore this hunk
>  		next if ($realfile !~ /\.(h|c)$/);

