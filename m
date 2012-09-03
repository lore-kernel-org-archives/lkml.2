Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2ICSNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:13:45 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:37541 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398Ab2ICSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:13:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAKTyRFBtggBP/2dsb2JhbABFhgW1HoEIgiABAQUjBC8jEAsYAgImAgIUJSSIJAenVZJZgSGJbIYRMmADlViQG4Jl
Date: Mon, 3 Sep 2012 20:13:35 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120903181335.GA415@vandijck-laurijssen.be>
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Wolfgang Grandegger <wg@grandegger.com>
References: <50191EA5.1040303@pengutronix.de>
 <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
 <20120824051016.GB1718@vandijck-laurijssen.be>
 <50376550.4020501@pengutronix.de>
 <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5044A547.2010603@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 02:40:39PM +0200, Marc Kleine-Budde wrote:
> On 08/25/2012 12:01 AM, Fabio Baltieri wrote:
> > Hello Kurt,
> > 
> > On Fri, Aug 24, 2012 at 02:42:48PM +0200, Kurt Van Dijck wrote:
> >> On Fri, Aug 24, 2012 at 01:28:16PM +0200, Marc Kleine-Budde wrote:
> >>> On 08/24/2012 07:10 AM, Kurt Van Dijck wrote:
> >>>> Hello,
> >>>>
> >>>> I find the CAN led triggers an interesting thing.
> >>>>
> >>>> And then, this scenario fell crossed my mind:
> >>>> Imagine I do:
> >>>> [insert CAN device: can0]
> >>>> $ ip link set can0 name helga
> >>>> [insert another CAN device: again 'can0']
> >>>>
> >>>> Registering 'can0-tx' led trigger will fail for the second CAN device,
> >>>> since that led trigger name is already reserved for CAN device 'helga'.
> >>> Good point.
> > 
> > Yep, thanks for pointing that out!
> > 
> > Interface renaming was something I considered when I first wrote the
> > code and I had the mac80211-led driver in mind, as that driver uses the
> > phy name and not the netdev one for its triggers.
> > 
> > The reason why I did not care that much in the end is that on SoC based
> > systems trigger-led association is made at probe time, based on data
> > either from platform_data or devicetree, so I imagined that once the
> > kernel is ported to the board and default triggers are set correctly at
> > boot time, the userspace is free to rename CAN interfaces and nobody
> > should notice... :^)
> > 
> > The thing I did not consider are hot-plug interfaces mixed with
> > renaming, such as in the case you pointed out - it's probably not really
> > common but still possible.
> > 
> >>>> I'm not sure how to fix such.
> >>>> If 'rx' & 'tx' may be combined, reusing the netdev name may be possible?
> >>>> Just wild thinking ...
> >>>
> >>> I think the device's name (not netdev) is unique in the system and
> >>> cannot be changed.
> >>
> >> but may contain several netdev's ...
> > 
> > Ouch.
> 
> The net->ifindex is unique. But it's only an integer. Usually can0 has a
> ifindex != 0, so a simple can%d is contra productive here.
> 
> Some pointers to related code:
> http://lxr.free-electrons.com/source/drivers/base/core.c#L1847
> http://lxr.free-electrons.com/source/drivers/base/core.c#L73
> http://lxr.free-electrons.com/source/include/linux/device.h#L695
> 
> comments?

a very recent idea: something with netdevice notifiers and NETDEV_CHANGENAME ...
http://lxr.free-electrons.com/source/net/core/dev.c#L1030

you could: rename the trigger, or if we think it's usefull,
block the netdev rename when its triggers are in use.

Kurt
