Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0EAPIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 11:08:32 -0400
Received: from tex.lwn.net ([70.33.254.29]:48432 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab0EAPIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 11:08:30 -0400
Date: Sat, 1 May 2010 09:08:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 12/30] viafb: Move core stuff into via-core.c
Message-ID: <20100501090827.72e9da71@bike.lwn.net>
In-Reply-To: <4BDC4286.4070703@gmx.de>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-13-git-send-email-corbet@lwn.net>
	<4BDC4286.4070703@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 May 2010 17:02:30 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> >  struct fb_info *viafbinfo;
> > +EXPORT_SYMBOL_GPL(viafbinfo);
> >  struct fb_info *viafbinfo1;
> >  struct viafb_par *viaparinfo;
> > +EXPORT_SYMBOL_GPL(viaparinfo);
> >  struct viafb_par *viaparinfo1;  
> 
> Ugh, I really hope you introduce those only as temporary exports until 
> the split is finished. It's ugly enough that viafb uses these internally 
> as global variables which will vanish in some time but for a 
> multifunction driver having those sounds even more ridiculous. If we 
> agree that it's only a temporary solution I'll take this bitter pill.

No we don't agree...  what we're seeing here is some history that I did
not succeed in getting rid of entirely.  Those exports have no reason
to exist anymore and shouldn't have slipped through into that patch.  I
will most certainly make them go away.

> > @@ -1764,6 +1765,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
> >  		&viaparinfo->shared->lvds_setting_info2;
> >  	viaparinfo->crt_setting_info = &viaparinfo->shared->crt_setting_info;
> >  	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
> > +	spin_lock_init(&viaparinfo->reg_lock);  
> 
> I think the initialization of the lock that is made for synchronization 
> of hardware access should be in the via-core.c you just introduce. (and 
>   the lock itself in a structure or something outside the framebuffer 
> flow). Just saw that you did so in your next patch, so there is no 
> reason to needlessly introduce the spinlock now.

As you note, it's only there for one step in the series, and no
electrons are harmed in the process.  Is this really worth the trouble
of changing?

Thanks,

jon
