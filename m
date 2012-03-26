Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2CZTgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:36:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2CZTgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:36:14 -0400
Date: Mon, 26 Mar 2012 14:36:08 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Michael Green <green@qca.qualcomm.com>,
        David Quan <dquan@qca.qualcomm.com>,
        Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120326193608.GE17126@thinkpad-t410>
Mail-Followup-To: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
References: <20120308200734.GC28133@ubuntu-macmini>
 <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <20120320220706.GA17272@thinkpad-t410>
 <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410>
 <4F6A1514.9090907@broadcom.com>
 <20120321181753.GC24075@tux>
 <20120321193706.GC23643@thinkpad-t410>
 <20120322002715.GA3709@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322002715.GA3709@tux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 05:27:15PM -0700, Luis R. Rodriguez wrote:
> > Arend, in order to proceed it looks like what we need to know is what
> > the custom domains represent, i.e. whether they map to a specific
> > country or set of countries, etc.
> 
> This is why it is crucial for vendors themselves to get involved in this
> process. Only they will truly know and completely understand what this
> all means. Since it is hard to keep track of this information it is also
> why we have documented what our EEPROM regulatory domains look like and
> what they mean / map to.
> 
> http://wireless.kernel.org/en/users/Drivers/ath
> 
> Something similar may be worthy for this driver. But just my own 0.02
> costarican colones.
> 
> > From what you've said so far it looks
> > like X0 may map to US 
> 
> BTW if this is the case, you may be able to send the regulatory hint
> for "US" and then apply any thing you need on top of that after
> through the reg_notifier() callback.
> 
> > while X2 is more of a world roaming domain, but again I'm just guessing.

I've been studying the existing brcmsmac regulatory code in more detail,
and I think there's a lot of potential to make the integration with the
core regulatory support much better. I'm still making my way through
some of the code, but here's what I see so far.

Once full and accurate regdomain information is provided to the core
regulatory code, all the code in channel.c that's checking against
regulatory constraints can be eliminated, as that will get done at a
higher level. I think the code to set the Tx power should also be
reworked to use the constraints from the core regdom code. At that point
the need for the custom regdom structures is mostly eliminated.

I'm going to start toying with implementing some of this this week, time
permitting. I think X2 is the only domain I have enough information on
to realistically implement. But even with that one it would be helpful
to understand what it's meant to represent, as Luis pointed out.

I have one other question as well. Does the data in channel.c generally
represent the most permissive regulatory parameters that ought to be
used? That's the assumption I'm working under right now.

Thanks,
Seth

