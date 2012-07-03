Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab2GCMGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:06:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:2949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab2GCMGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:06:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172914330"
Date: Tue, 3 Jul 2012 20:05:57 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Vladimir Kondratiev <vkondrat@qualcomm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mac80211-next:for-john] WARNING: at
 /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
Message-ID: <20120703120557.GA872@localhost>
References: <20120703112726.GA32627@localhost>
 <3533322.B33xrWD3rS@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3533322.B33xrWD3rS@lx-vladimir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir: Got it, thanks!

On Tue, Jul 03, 2012 at 02:59:31PM +0300, Vladimir Kondratiev wrote:
> Hi,
> 
> This is addressed by the patch from Johannes Berg:
> 
> http://p.sipsolutions.net/a1c40eea7e33541b.txt
> 
> See his other mail.
> 
> On Tuesday, July 03, 2012 07:27:26 PM wfg@linux.intel.com wrote:
> > Hi Vladimir,
> > 
> > The below commit triggers a warning.
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.gi
> > t for-john head:   ba0afa2f22e1e3f332e45460f99328025d44564e
> > commit: 3a0c52a6d82cc41da965284412608c74aece34e4 [648/651] cfg80211: add
> > 802.11ad (60gHz band) support
> > 
> > 647:    b d9b3b28  2012-07-02 14:47:44 +0200  mac80211: allow calling
> > ieee80211_ap_probereq_get() during auth/assoc 648:    B
> > 3a0c52a  [   72.865235] WARNING: at
> > /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
> > 649:    B 90cdc6d  [   64.868502] WARNING: at
> > /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
> > 650:    B b188148  [   30.024352] WARNING: at
> > /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
> > 651:    B ba0afa2  [   77.237955] WARNING: at
> > /c/kernel-tests/net/net/wireless/core.c:471 wiphy_register+0x401/0x451()
> > [b] boot OK [B] kernel boots with some problem
> > 
> > [   72.862898] mac80211_hwsim: Initializing radio 0
> > [   72.864155] ------------[ cut here ]------------
> > [   72.865235] WARNING: at /c/kernel-tests/net/net/wireless/core.c:471
> > wiphy_register+0x401/0x451() [   72.867261] Hardware name: Bochs
> > [   72.868096] Modules linked in:
> > [   72.868885] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1+ #4
> > [   72.870152] Call Trace:
> > [   72.870885]  [<ffffffff81090261>] warn_slowpath_common+0x83/0x9c
> > [   72.872241]  [<ffffffff81090294>] warn_slowpath_null+0x1a/0x1c
> > [   72.873542]  [<ffffffff82c293e3>] wiphy_register+0x401/0x451
> > [   72.874835]  [<ffffffff811758a0>] ? __kmalloc+0x128/0x13a
> > [   72.876069]  [<ffffffff82c46713>] ? ieee80211_register_hw+0x113/0x5dc
> > [   72.877473]  [<ffffffff82c469a4>] ieee80211_register_hw+0x3a4/0x5dc
> > [   72.878944]  [<ffffffff8464e113>] init_mac80211_hwsim+0x423/0x6a0
> > [   72.880294]  [<ffffffff8464dcf0>] ? carl9170_driver_init+0x1b/0x1b
> > [   72.881671]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
> > [   72.882985]  [<ffffffff845f0d39>] kernel_init+0x170/0x1f8
> > [   72.884215]  [<ffffffff845f0590>] ? do_early_param+0x8c/0x8c
> > [   72.885483]  [<ffffffff82e516b4>] kernel_thread_helper+0x4/0x10
> > [   72.886787]  [<ffffffff82e498f0>] ? retint_restore_args+0x13/0x13
> > [   72.888244]  [<ffffffff845f0bc9>] ? start_kernel+0x3e7/0x3e7
> > [   72.889506]  [<ffffffff82e516b0>] ? gs_change+0x13/0x13
> > [   72.890695] ---[ end trace bd81035d49db0c0f ]---
> > [   72.891797] mac80211_hwsim: ieee80211_register_hw failed (-22)
> > 
> > commit 3a0c52a6d82cc41da965284412608c74aece34e4
> > Author: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> > Date:   Mon Jul 2 09:32:32 2012 +0300
> > 
> >     cfg80211: add 802.11ad (60gHz band) support
> >     
> >     Add enumerations for both cfg80211 and nl80211.
> >     This expands wiphy.bands etc. arrays.
> >     
> >     Extend channel <-> frequency translation to cover 60g band
> >     and modify the rate check logic since there are no legacy
> >     mandatory rates (only MCS is used.)
> >     
> >     Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> >     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
