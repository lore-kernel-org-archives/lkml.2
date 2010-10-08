Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab0JHPBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:01:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55667 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab0JHPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jHzWgMkE4TMoo1p41DrDt2C2T+8NvD9wtLdKGXaitAtq7f/O41pot1DT5r6lXm0/8o
         WCmI0WiKKLJSG9sO/BCaTlrHWEURUK2cFXkIivCE3mGaTKYNa2lwzPI1FEQT/4ua0VAh
         yE63G+C0AL1e5sQXYMre6/MBDpgkQh87frtT8=
Date: Fri, 8 Oct 2010 23:03:43 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: linux-next: build warnings after merge of the kbuild-current
	tree
Message-ID: <20101008150343.GF4088@hack>
References: <20101006114433.4fbe86ef.sfr@canb.auug.org.au> <4CAC59D4.5010505@suse.cz> <1286365363.4281.5.camel@e102109-lin.cambridge.arm.com> <20101008145141.GA13688@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008145141.GA13688@sepie.suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:51:41PM +0200, Michal Marek wrote:
>
>From ca22d6b4c7c26a8ff9092036a9524bc5ba817277 Mon Sep 17 00:00:00 2001
>From: Michal Marek <mmarek@suse.cz>
>Date: Fri, 8 Oct 2010 16:40:27 +0200
>Subject: [PATCH] kconfig: Temporarily disable dependency warnings
>
>After fixing a use-after-free bug in kconfig, a 'make defconfig' or
>'make allmodconfig' fills the screen with warnings that were not
>detected before. Given that we are close to the release now, disable the
>warnings temporarily and deal with them after 2.6.36.
>
>Signed-off-by: Michal Marek <mmarek@suse.cz>
>
>diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
>index 943712c..d3cfa49 100644
>--- a/scripts/kconfig/symbol.c
>+++ b/scripts/kconfig/symbol.c
>@@ -350,7 +350,7 @@ void sym_calc_value(struct symbol *sym)
> 				}
> 			}
> 		calc_newval:
>-			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
>+			if (0 && sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
> 				fprintf(stderr, "warning: (");
> 				expr_fprint(sym->rev_dep.expr, stderr);
> 				fprintf(stderr, ") selects %s which has unmet direct dependencies (",

Well, this is an odd way to comment a block of code out,
usually we use #ifdef 0 instead. :)


-- 
Live like a child, think like the god.
 
