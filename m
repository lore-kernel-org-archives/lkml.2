Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2LQM7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:59:10 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46093 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2LQM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <20687.3736.365327.811519@pilspetsen.it.uu.se>
References: <20686.63778.840426.61474@pilspetsen.it.uu.se>
	<CAHdPZaPQNQ1WS5Qkb4FpmmOX7mXL10HsdaXf5dctp2hd2T0Sow@mail.gmail.com>
	<20687.3736.365327.811519@pilspetsen.it.uu.se>
Date: Mon, 17 Dec 2012 07:59:06 -0500
Message-ID: <CAHdPZaNOK=isKPZtxYaBFsGvcpN0261wExaXgRYjg5N3Y7qJZg@mail.gmail.com>
Subject: Re: [3.7.0 regression] rt2x00lib_probe_dev: Error - Failed to
 initialize hw
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 7:22 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> devendra.aaru writes:
>  > On Mon, Dec 17, 2012 at 5:51 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>  > > I just updated an old 1st gen AMD64 laptop from kernel 3.6.0 to 3.7.0,
>  > > Fedora 15 user-space, and was greeted by the following kernel warning:
>  > >
>  > > WARNING: at net/wireless/core.c:389 wiphy_register+0x5c3/0x600 [cfg80211]()
>  >
>  > I am seeing this line actually when i do vim +389 net/wireless/core.c.
>  >
>  >                 u16 all_iftypes = 0;
>  >
>  > its good if you tell us the top sha1 of yours?
>
> It's the plain linux-3.7.tar.xz from kernel.org, no git involved.
> Lines 389-390 of net/wireless/core.c are:
>
>                 if (WARN_ON(c->max_interfaces < 2))
>                         return -EINVAL;
>

so its v3.7 tag hash 29594404d7fe73cd80eaa4ee8c43dcc53970c60e.

i see that code line :). thanks

i traced a while and looked at the rt2500pci.c code and there we are
assigning the max_ap_intf variable to 1. the same go with the
rt2800pci.c

here's the part of the ops structure

static const struct rt2x00_ops rt2500pci_ops = {
        .name                   = KBUILD_MODNAME,
        .max_ap_intf            = 1,
        .eeprom_size            = EEPROM_SIZE,
        .rf_size                = RF_SIZE,
        .tx_queues              = NUM_TX_QUEUES,
        .extra_tx_headroom      = 0,
        .rx                     = &rt2500pci_queue_rx,
        .tx                     = &rt2500pci_queue_tx,
        .bcn                    = &rt2500pci_queue_bcn,
        .atim                   = &rt2500pci_queue_atim,
        .lib                    = &rt2500pci_rt2x00_ops,
        .hw                     = &rt2500pci_mac80211_ops,
#ifdef CONFIG_RT2X00_LIB_DEBUGFS
        .debugfs                = &rt2500pci_rt2x00debug,
#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
};

i really dont know why is that max_ap_intf is 1. may be some wireless
dev's know about this?


> /Mikael
>
