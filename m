Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0DWU6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:58:46 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54892 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab0DWU6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:58:44 -0400
Date: Fri, 23 Apr 2010 13:58:16 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Erwan Velu <erwanaliasr1@gmail.com>, netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       alexander.h.duyck@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com
Subject: Re: [PATCH] e100: expose broadcast_disabled as a module option
Message-ID: <20100423135816.23f5861f@nehalam>
In-Reply-To: <h2p9929d2391004231322r23528f32z8447a711a29e28ea@mail.gmail.com>
References: <l2nb43bf5491004231314i13503c67yeccfc54bc1cae850@mail.gmail.com>
	<h2p9929d2391004231322r23528f32z8447a711a29e28ea@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 13:22:22 -0700
Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:

> On Fri, Apr 23, 2010 at 13:14, Erwan Velu <erwanaliasr1@gmail.com> wrote:
> > Hi folks,
> >
> > I've been facing a very noisy network where hundreds broadcast packets
> > were generated every second.
> > When this traffic can't be controlled at the source, there is a side
> > effect on some systems.
> > I was having some idle systems that will never be targeted by this
> > broadcast traffic that got loaded just by receiving that "flood".
> > I mean by loaded that this light hardware was generating 300
> > context/switches per second.
> >
> > I was looking for many options to avoid this traffic to disturb this
> > hosts and I discovered that the e100 driver was featuring a
> > "broadcast_disabled" configure option.
> > I realize that this option is not controllable, so I wrote this simple
> > patch that expose this option as a module option.
> > This allow me to tell this hosts not to listen anymore this traffic.
> >
> > The result is clearly good as my systems are now running at 21
> > context/switches while being idle.
> > Hope this patch isn't too bad and could help others that faces the same problem.
> >
> > Patch can be downloaded here :
> > http://konilope.linuxeries.org/e100_broadcast_disabled.patch
> >
> > Even if gmail is eating the inlined, patch, at least that make it
> > easier to read it for humans.
> > If the patch is acked, the downloaded one will be more clean ;)
> >
> > This patch was generated on top of the latest 2.6 torvald's git.
> > Cheers,
> > Erwan
> >
> > Signed-off-by: Erwan Velu <erwanaliasr1@gmail.com>
> >
> > diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> > index b997e57..2ba582f 100644
> > --- a/drivers/net/e100.c
> > +++ b/drivers/net/e100.c
> > @@ -194,12 +194,15 @@ MODULE_FIRMWARE(FIRMWARE_D102E);
> >  static int debug = 3;
> >  static int eeprom_bad_csum_allow = 0;
> >  static int use_io = 0;
> > +static int broadcast_disabled = 0;
> >  module_param(debug, int, 0);
> >  module_param(eeprom_bad_csum_allow, int, 0);
> >  module_param(use_io, int, 0);
> > +module_param(broadcast_disabled, int, 0);
> >  MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
> >  MODULE_PARM_DESC(eeprom_bad_csum_allow, "Allow bad eeprom checksums");
> >  MODULE_PARM_DESC(use_io, "Force use of i/o access mode");
> > +MODULE_PARM_DESC(broadcast_disabled, "Filter broadcast packets
> > (0=disabled (default), 1=enabled)");
> >  #define DPRINTK(nlevel, klevel, fmt, args...) \
> >        (void)((NETIF_MSG_##nlevel & nic->msg_enable) && \
> >        printk(KERN_##klevel PFX "%s: %s: " fmt, nic->netdev->name, \
> > @@ -1131,6 +1134,8 @@ static void e100_configure(struct nic *nic,
> > struct cb *cb, struct sk_buff *skb)
> >                config->promiscuous_mode = 0x1;         /* 1=on, 0=off */
> >        }
> >
> > +       config->broadcast_disabled = broadcast_disabled; /* Broadcast filtering */
> > +
> >        if (nic->flags & multicast_all)
> >                config->multicast_all = 0x1;            /* 1=accept, 0=no */
> > --
> 
> Adding Netdev...
> 

What is wrong with using existing IFF_BROADCAST flag?


-- 
