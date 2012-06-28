Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab2F1HvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:51:25 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab2F1HvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:51:24 -0400
Message-ID: <1340869868.4491.4.camel@jlt3.sipsolutions.net>
Subject: Re: [Ilw] 	Re: 3.4-rc2, ilwagn still most of the time completely
 unusable
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
        "Lin, Hsien KuoX" <hsien.kuox.lin@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <egrumbach@gmail.com>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Date: Thu, 28 Jun 2012 09:51:08 +0200
In-Reply-To: <20120628072512.GF31944@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
	 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
	 <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
	 <20120413014047.GB25681@gamma.logic.tuwien.ac.at>
	 <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
	 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
	 <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
	 <20120628072512.GF31944@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

> I am coming back to this old thread, not because it has been solved,

Somehow your mail didn't make it to the lists, not sure why.

> but because today I got a funny new message while checking why
> everything got stuck again:
>         [69588.972126] iwlwifi 0000:06:00.0: fail to flush all tx fifo queues
> and after doing
>         rfkill block wifi
>         sleep 20
>         rfkill unblock wifi
> I got a kernel warning:
> [76477.289251] WARNING: at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x14e/0x1ca [mac80211]()
> [76477.289256] Hardware name: VGN-Z11VN_B
> [76477.289260] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
> [76477.289350] Modules linked in: ...
> [76477.289361] Pid: 4278, comm: NetworkManager Tainted: P        W  O 3.5.0-rc4+ #78
> [76477.289365] Call Trace:
> [76477.289380]  [<ffffffff8102ba46>] warn_slowpath_common+0x83/0x9c
> [76477.289389]  [<ffffffff8102bb02>] warn_slowpath_fmt+0x46/0x48
> [76477.289402]  [<ffffffff813f21da>] ? neigh_ifdown+0xc5/0xd6
> [76477.289424]  [<ffffffffa00b252e>] ieee80211_bss_info_change_notify+0x14e/0x1ca [mac80211]
> [76477.289448]  [<ffffffffa00b267d>] ieee80211_ifa_changed+0xd3/0xe6 [mac80211]
> [76477.289458]  [<ffffffff8104b7e3>] notifier_call_chain+0x37/0x61
> [76477.289467]  [<ffffffff8104b919>] __blocking_notifier_call_chain+0x46/0x5f
> [76477.289475]  [<ffffffff8104b946>] blocking_notifier_call_chain+0x14/0x16
> [76477.289485]  [<ffffffff81432cc0>] __inet_del_ifa+0x176/0x22c
> [76477.289494]  [<ffffffff81432f96>] inet_rtm_deladdr+0xe7/0x128
> [76477.289504]  [<ffffffff813f61e0>] rtnetlink_rcv_msg+0x226/0x235

Fun. I don't actually see how this can possibly happen though?!


> Maybe this tells you something.
> 
> > > >   [ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active
> > > >station id 0 addr 00:24:c4:ab:bd:e0
> 
> These messages now appear only now and then.

I fixed those recently.

You seem to be on 3.5.0-rc now, is that really no different from 3.4?

johannes

