Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab0EXSRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:17:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37780 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0EXSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ah7KQlZPRXGqQuE+d9tMl+4DYtCpk1CD97phdxk/KLmRGT36hAPa5WhtW3QNspwW6d
         WcBae4lJbP0WyxbPQeov7dcxPD4338Ges3QNyAM0CmCBrAyXJN461pggKC1fDz94khFC
         w3INTJwR0HQX6oABfE2A1k8wdfi7T/RZ2XqPI=
Date: Mon, 24 May 2010 11:17:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kgdb tree
Message-ID: <20100524181735.GC6033@core.coreip.homeip.net>
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au>
 <20100325154307.9cdeae10.sfr@canb.auug.org.au>
 <201003242159.25770.dmitry.torokhov@gmail.com>
 <20100521102158.bf6df441.sfr@canb.auug.org.au>
 <4BF5D8AF.6010408@windriver.com>
 <20100521110938.7bbbbf59.sfr@canb.auug.org.au>
 <20100521012340.GA12372@core.coreip.homeip.net>
 <4BF5E1D6.1090607@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF5E1D6.1090607@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 08:28:54PM -0500, Jason Wessel wrote:
> On 05/20/2010 08:23 PM, Dmitry Torokhov wrote:
> > On Fri, May 21, 2010 at 11:09:38AM +1000, Stephen Rothwell wrote:
> >> Hi Jason,
> >>
> >> On Thu, 20 May 2010 19:49:51 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
> >>> Before brute force toggling it, it seems we should check the value and
> >>> restore it after the execution of handle_sysrq().
> >> Indeed, at the time I couldn't find an easy way to do that.
> >>
> >>> I'll have to look and see if there is an access function for this.
> >> Great, thanks.
> > 
> > I would not mind re-exporting sysrq_on() again.
> > 
> 
> We could but I don't know that you need to.
> 
> Would you be willing to sign off on a change like the one below
> Dmitry?  If so then I'll push it into kgdb-next.
> 
> It is as simple as making the return from sysrq_toggle_support a bit
> more meaningful.
>

I do not think it is a very good idea... What if some other process
enales SysRq in the mean time. Do we really need to force SysRq on
or off? Maybe we should export __handle_sysrq() instead?

Also, I think I need to add locking in sysrq_toggle_support(), which
will make it unsuitable for using in kdb handler, won't it?

-- 
Dmitry
