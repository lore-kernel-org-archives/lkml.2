Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0KOS66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:58:58 -0500
Received: from kroah.org ([198.145.64.141]:43658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab0KOS65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:58:57 -0500
Date: Mon, 15 Nov 2010 10:44:22 -0800
From: Greg KH <greg@kroah.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Message-ID: <20101115184422.GA9566@kroah.com>
References: <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
 <20101113235938.GA1827@kroah.com>
 <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 06:45:24PM +0100, Bart Van Assche wrote:
> On Sun, Nov 14, 2010 at 12:59 AM, Greg KH <greg@kroah.com> wrote:
> >
> > On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> > > So, I decided to reimplement it to be completely synchronous. SYSFS
> > > authors did really great job and thanks to the excellent internal SYSFS
> > > design and implementation it is absolutely safe. See:
> > >
> > > [root@tgt ~]# modprobe scst
> > > [root@tgt ~]# cd /sys/kernel/scst_tgt/
> >
> > Sorry, but no, you can't put this in /sys/kernel/ without getting the
> > approval of the sysfs maintainer.
> >
> > I really don't understand why you are using kobjects in the first place,
> > why isn't this in the main device tree in the kernel, using 'struct
> > device'?
> 
> We might have missed something, but as far as we know it has not yet
> been explained in this thread why using 'struct device' would be an
> advantage over using 'struct kobject'.

It's very simple.

You want your device to show up in the global device tree in the kernel,
not off to one side, unconnected to anything else.

Please use 'struct device', it is what you want to do here.

good luck,

greg k-h
