Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1CHPBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:01:21 -0500
Received: from www.tglx.de ([62.245.132.106]:59953 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1CHPBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:01:20 -0500
Date: Tue, 8 Mar 2011 16:01:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 1/1] PRUSS UIO driver support
In-Reply-To: <201103081424.01476.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103081600450.2787@localhost6.localdomain6>
References: <1299175677-17859-1-git-send-email-pratheesh@ti.com> <B85A65D85D7EB246BE421B3FB0FBB593024C008B02@dbde02.ent.ti.com> <alpine.LFD.2.00.1103081133510.2787@localhost6.localdomain6> <201103081424.01476.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, Arnd Bergmann wrote:

> On Tuesday 08 March 2011, Thomas Gleixner wrote:
> > > 
> > > +static irqreturn_t pruss_handler(int irq, struct uio_info *info) {
> > > +     struct pruss_priv *priv = info->priv;
> > > +     struct uio_pruss_dev *gdev = priv->pupdev;
> > > 
> > > Note that info is a pointer to array supporting 8 interrupts. This allows to
> > > redirect to driver structure via info->priv quickly.
> > 
> > struct uio_pruss_dev *dev = container_of(info, struct uio_pruss_dev, info);
> > 
> > Perhaps ?
> 
> That would require having the same number of uio_info structs as uio_pruss_dev
> instances. Right now, one platform device has one uio_pruss_dev instance, which
> has 8 uio_info instances, so the container_of() trick doesn't work.

Duh. Yes :)

     tglx
