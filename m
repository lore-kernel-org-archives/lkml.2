Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab2DKNjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:39:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab2DKNjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:39:47 -0400
Date: Wed, 11 Apr 2012 08:39:40 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Michael Green <green@qca.qualcomm.com>,
        David Quan <dquan@qca.qualcomm.com>,
        Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120411133940.GA15854@thinkpad-t410>
Mail-Followup-To: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
References: <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410>
 <4F6A1514.9090907@broadcom.com>
 <20120321181753.GC24075@tux>
 <20120321193706.GC23643@thinkpad-t410>
 <20120322002715.GA3709@tux>
 <20120326193608.GE17126@thinkpad-t410>
 <20120404024632.GA13090@thinkpad-t410>
 <20120410162833.GD21994@thinkpad-t410>
 <4F855A08.6070902@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F855A08.6070902@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:16:40PM +0200, Arend van Spriel wrote:
> On 04/10/2012 06:28 PM, Seth Forshee wrote:
> >>The patch builds, and kind of works. Scanning seems to be fine; I can
> >>>  see all the APs I expect in my area, including the one on a DFS channel
> >>>  that I couldn't see previously. I can associate with my 2.4 GHz APs, but
> >>>  not the 5 GHz AP. I see timme outs waiting for probe responses, and I'm
> >>>  hitting the WARN_ON_ONCE in brcms_c_wait_for_tx_completion(). I haven't
> >>>  really debugged this yet -- I thought I'd send out the patch to collect
> >>>  comments while I debug. Suggestions of what's causing this are also
> >>>  welcome:)
> >This was due to always passing true for the value of mute_tx to
> >brcms_b_set_chanspec() on passive channels. For now I'm just always
> >passing false, which looks like it ought to be okay as we shouldn't have
> >any tx on passive channels unless beacons are seen on the channel.
> 
> Yes. I discovered this as well. Actually, I sent out a patch for
> some people to test it. I submitted a slightly different patch to
> John in which tx in unmuted upon receiving a beacon.

I assume you're talking about this patch?

http://www.spinics.net/lists/linux-wireless/msg88107.html

My original changes would mute tx whenever IEEE80211_CHAN_PASSIVE_SCAN
is set for the current channel. I'll try that again with your patch.

> >>>  One of the major unresolved issues in the patch is what to do with the
> >>>  data in struct locale_mimo_info. The regulatory rules only hold one
> >>>  power level. I'm unsure why the brcmsmac implementation differs in this
> >>>  regard. Suggestions?
> >This is still one of the largest unsolved issues. I'm probably going to
> >need some advice on how to fill out the txpwr information when
> >regualtory rules external to the driver can be applied.
> >
> 
> The power constraints for HT (covered by struct locale_mimo_info)
> are handled differently from non-HT. I have to confirm internally
> whether this is specific for our devices or actually needed to be
> compliant.

Great, thanks.

Seth

