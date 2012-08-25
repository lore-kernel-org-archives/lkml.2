Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2HYU0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 16:26:15 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:17457 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab2HYU0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 16:26:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EADU0OVBtgi06/2dsb2JhbABFhgO0Z4EIgiABAQQBIysIIxALGAICJgICFB0IJAgLHQSHZgoHqUKSIIEhiWeFfzJgA5VUgRWPAYJl
Date: Sat, 25 Aug 2012 22:25:56 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120825202556.GC413@vandijck-laurijssen.be>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Wolfgang Grandegger <wg@grandegger.com>
References: <50191EA5.1040303@pengutronix.de>
 <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
 <20120824051016.GB1718@vandijck-laurijssen.be>
 <50376550.4020501@pengutronix.de>
 <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120824220142.GA1470@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 12:01:42AM +0200, Fabio Baltieri wrote:
> Hello Kurt,
> 
> On Fri, Aug 24, 2012 at 02:42:48PM +0200, Kurt Van Dijck wrote:
> > On Fri, Aug 24, 2012 at 01:28:16PM +0200, Marc Kleine-Budde wrote:
> > > On 08/24/2012 07:10 AM, Kurt Van Dijck wrote:
> > > > Hello,
> > > > 
> > > > I find the CAN led triggers an interesting thing.
> > > > 
> > > > And then, this scenario fell crossed my mind:
> > > > Imagine I do:
> > > > [insert CAN device: can0]
> > > > $ ip link set can0 name helga
> > > > [insert another CAN device: again 'can0']
> > > > 
> > > > Registering 'can0-tx' led trigger will fail for the second CAN device,
> > > > since that led trigger name is already reserved for CAN device 'helga'.
> > > Good point.
> 
> Yep, thanks for pointing that out!
> 
> Interface renaming was something I considered when I first wrote the
> code and I had the mac80211-led driver in mind, as that driver uses the
> phy name and not the netdev one for its triggers.
> 
> The reason why I did not care that much in the end is that on SoC based
> systems trigger-led association is made at probe time, based on data
> either from platform_data or devicetree, so I imagined that once the
> kernel is ported to the board and default triggers are set correctly at
> boot time, the userspace is free to rename CAN interfaces and nobody
> should notice... :^)
> 
> The thing I did not consider are hot-plug interfaces mixed with
> renaming, such as in the case you pointed out - it's probably not really
> common but still possible.
> 
> > > > I'm not sure how to fix such.
> > > > If 'rx' & 'tx' may be combined, reusing the netdev name may be possible?
> > > > Just wild thinking ...
> > > 
> > > I think the device's name (not netdev) is unique in the system and
> > > cannot be changed.
> >
> > but may contain several netdev's ...
> 
> Ouch.
> 
> > 
> > > 
> > > On my device tree enabled mx28 I'm talking about the "80032000.can" in:
> > 
> > You idea triggered another thougt: since control is put in device drivers,
> > why putting the name in the generic can_dev struct?
> 
> Why not?  That makes the API easy.

The code is not next to the data?
Anyway, I said the above because I think the led names need a per-device approach,
but the data is in common parts. That's where things start being complicated.
I understand the common part now because you mainly addressed the SoC based drivers.

> 
> > A more flexible approach to assign names is the key to success here.
> > The correct 'works in all conditions' approach is not yet in my sight :-(
> 
> Agreed.
> 
> What about using a combination of device name + an optional port index
> specified in devm_can_led_init()? (something like to platform_device names)
> Of course that would require changing the API for libraries like
> register_sja1000dev(), to add a port index.
> 
> Fabio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-can" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Kurt Van Dijck
GRAMMER EiA ELECTRONICS
http://www.eia.be
kurt.van.dijck@eia.be
+32-38708534
