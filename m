Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0DITbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:31:45 -0400
Received: from tex.lwn.net ([70.33.254.29]:34086 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab0DITbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:31:42 -0400
Date: Fri, 9 Apr 2010 13:31:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] [FB] viafb: Fix various resource leaks during
 module_init()
Message-ID: <20100409133139.1ab17828@bike.lwn.net>
In-Reply-To: <4BBE1F01.5000800@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-2-git-send-email-corbet@lwn.net>
	<4BBE1F01.5000800@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Apr 2010 20:22:57 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> >  	if (!viafbinfo->screen_base) {
> >  		printk(KERN_INFO "ioremap failed\n");
> > -		return -ENOMEM;
> > +		rc = -EIO;
> 
> I don't know whether this is right (changing the return code) as Andrew 
> recommend a while ago:
> "It should return -ENOMEM rather than -1, but that's minor."
> So I did and now I wonder which one is correct?

To me it seems like -ENOMEM could be a bit confusing here; there's a lot of
things that could go wrong with that same error return.

That said, I did some digging around, and -ENOMEM does seem to be the
standard response to an ioremap() failure.  So I've changed it back.

> >  		if (!viafbinfo1) {
> >  			printk(KERN_ERR
> >  			"allocate the second framebuffer struct error\n");
> > -			framebuffer_release(viafbinfo);
> > -			return -ENOMEM;
> 
> rc = -ENOMEM;
> is missing?

Indeed.  Fixed.

Thanks,

jon
