Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2JKNPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:15:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab2JKNPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:15:10 -0400
Date: Thu, 11 Oct 2012 15:15:09 +0200
From: Michal Marek <mmarek@suse.cz>
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Coccicheck: Add the rep+ctxt mode
Message-ID: <20121011131509.GB16465@sepie.suse.cz>
References: <CAAxaTiOsaHOR4cbwcq=xOn-sWxB6PdB4x_UgYf2rUsPQM=WwWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAxaTiOsaHOR4cbwcq=xOn-sWxB6PdB4x_UgYf2rUsPQM=WwWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:30:46PM +0200, Nicolas Palix wrote:
> This adds a 'rep+ctxt' mode which prints the warning
> message followed by the context.
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
> ---
>  scripts/coccicheck | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 823e972..eb43e40 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -95,6 +95,9 @@ coccinelle () {
>  	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
>  	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
>  	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS
> -no_show_diff || exit 1

Your mailer broke this line into two, please try to avoid this next
time. Also, please CC lkml when submitting patches. I applied the patch
to kbuild.git#misc now.

Michal

> +    elif [ "$MODE" = "rep+ctxt" ] ; then
> +	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
> +	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS
>  || exit 1
>      else
>  	$SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
>      fi
> -- 
> 1.7.11.3
