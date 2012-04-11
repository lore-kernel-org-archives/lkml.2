Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2DKKQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:16:55 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4787 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab2DKKQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:16:53 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F855A08.6070902@broadcom.com>
Date: Wed, 11 Apr 2012 12:16:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Michael Green" <green@qca.qualcomm.com>,
        "David Quan" <dquan@qca.qualcomm.com>,
        "Henry Ptasinski" <henry@logout.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with regulatory domain support and BCM43224
References: <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <20120320220706.GA17272@thinkpad-t410> <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410> <4F6A1514.9090907@broadcom.com>
 <20120321181753.GC24075@tux> <20120321193706.GC23643@thinkpad-t410>
 <20120322002715.GA3709@tux> <20120326193608.GE17126@thinkpad-t410>
 <20120404024632.GA13090@thinkpad-t410>
 <20120410162833.GD21994@thinkpad-t410>
In-Reply-To: <20120410162833.GD21994@thinkpad-t410>
X-WSS-ID: 639B83C53E016317626-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 06:28 PM, Seth Forshee wrote:
>> The patch builds, and kind of works. Scanning seems to be fine; I can
>> >  see all the APs I expect in my area, including the one on a DFS channel
>> >  that I couldn't see previously. I can associate with my 2.4 GHz APs, but
>> >  not the 5 GHz AP. I see timme outs waiting for probe responses, and I'm
>> >  hitting the WARN_ON_ONCE in brcms_c_wait_for_tx_completion(). I haven't
>> >  really debugged this yet -- I thought I'd send out the patch to collect
>> >  comments while I debug. Suggestions of what's causing this are also
>> >  welcome:)
> This was due to always passing true for the value of mute_tx to
> brcms_b_set_chanspec() on passive channels. For now I'm just always
> passing false, which looks like it ought to be okay as we shouldn't have
> any tx on passive channels unless beacons are seen on the channel.

Yes. I discovered this as well. Actually, I sent out a patch for some 
people to test it. I submitted a slightly different patch to John in 
which tx in unmuted upon receiving a beacon.

>> >  One of the major unresolved issues in the patch is what to do with the
>> >  data in struct locale_mimo_info. The regulatory rules only hold one
>> >  power level. I'm unsure why the brcmsmac implementation differs in this
>> >  regard. Suggestions?
> This is still one of the largest unsolved issues. I'm probably going to
> need some advice on how to fill out the txpwr information when
> regualtory rules external to the driver can be applied.
>

The power constraints for HT (covered by struct locale_mimo_info) are 
handled differently from non-HT. I have to confirm internally whether 
this is specific for our devices or actually needed to be compliant.

Gr. AvS

