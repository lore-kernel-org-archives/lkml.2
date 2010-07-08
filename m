Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0GHE4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:56:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36140 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0GHE4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NDEwZLM5KlqfRQTsgKCXdz1sc1TvE/iAi6gHiAl/LsErU9V3bTfUEAdWPmQ+iscVNZ
         WXKEMWT0V8a0HQTiCN6On8dvzssPZXbH8cvfNkEwsypFeXT24TwNhnq+2fyu/32Ycaz8
         9gQKwF+5p9+ZSwpVkoQ3fGLU8iOE5grLkxRuU=
Date: Thu, 8 Jul 2010 08:56:27 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
       Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] edac: mpc85xx: Fix MPC85xx dependency
Message-ID: <20100708045627.GA32489@oksana.dev.rtsoft.ru>
References: <20100702124111.GA23320@oksana.dev.rtsoft.ru>
 <20100707144502.22b91374.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100707144502.22b91374.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 02:45:02PM -0700, Andrew Morton wrote:
> On Fri, 2 Jul 2010 16:41:11 +0400
> Anton Vorontsov <avorontsov@mvista.com> wrote:
> 
> > Since commit 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx:
> > Kconfig cleanup"), there is no MPC85xx Kconfig symbol anymore, so the
> > driver became non-selectable.
> 
> hm.  5753c082f66eca5be81f6bda85c1718c5eea6ada got merged into mainline
> six months ago.  How come nobody noticed?

Dunno. Well, it's hard to notice these sorts of things until
somebody actually needs this driver on MPC85xx platform. :-)

> > This patch fixes the issue by switching to PPC_85xx symbol.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> > ---
[...]
> > -	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
> > +	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
> >  	help
> >  	  Support for error detection and correction on the Freescale
> >  	  MPC8349, MPC8560, MPC8540, MPC8548
> 
> I suppose we shold scoot this into 2.6.35 and mark it for -stable
> backporting.  All very odd.

Yeah, -stable 2.6.{33,34} sounds good.

Thanks.
