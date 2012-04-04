Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2DDHDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:03:38 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4754 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab2DDHDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:03:37 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F7BF234.10900@broadcom.com>
Date: Wed, 4 Apr 2012 09:03:16 +0200
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
References: <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <20120320220706.GA17272@thinkpad-t410> <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410> <4F6A1514.9090907@broadcom.com>
 <20120321181753.GC24075@tux> <20120321193706.GC23643@thinkpad-t410>
 <20120322002715.GA3709@tux> <20120326193608.GE17126@thinkpad-t410>
 <20120404024632.GA13090@thinkpad-t410>
In-Reply-To: <20120404024632.GA13090@thinkpad-t410>
X-WSS-ID: 63652BF73E013689749-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 04:46 AM, Seth Forshee wrote:
> On Mon, Mar 26, 2012 at 02:36:08PM -0500, Seth Forshee wrote:
>> I've been studying the existing brcmsmac regulatory code in more detail,
>> and I think there's a lot of potential to make the integration with the
>> core regulatory support much better. I'm still making my way through
>> some of the code, but here's what I see so far.
>>
>> Once full and accurate regdomain information is provided to the core
>> regulatory code, all the code in channel.c that's checking against
>> regulatory constraints can be eliminated, as that will get done at a
>> higher level. I think the code to set the Tx power should also be
>> reworked to use the constraints from the core regdom code. At that point
>> the need for the custom regdom structures is mostly eliminated.
>>
>> I'm going to start toying with implementing some of this this week, time
>> permitting. I think X2 is the only domain I have enough information on
>> to realistically implement. But even with that one it would be helpful
>> to understand what it's meant to represent, as Luis pointed out.
>>
>> I have one other question as well. Does the data in channel.c generally
>> represent the most permissive regulatory parameters that ought to be
>> used? That's the assumption I'm working under right now.
>
> Below is a diff of the changes I've made locally to the brcmsmac
> regulatory support. I haven't started thinking about dividing it up into
> more digestible chunks, so for now it's just one massive diff. I've made
> a lot of progress towards moving brcmsmac away from its custom formats
> for regulatory information, but there are a few points I'm still having
> difficulty with.
>
> The patch builds, and kind of works. Scanning seems to be fine; I can
> see all the APs I expect in my area, including the one on a DFS channel
> that I couldn't see previously. I can associate with my 2.4 GHz APs, but
> not the 5 GHz AP. I see timme outs waiting for probe responses, and I'm
> hitting the WARN_ON_ONCE in brcms_c_wait_for_tx_completion(). I haven't
> really debugged this yet -- I thought I'd send out the patch to collect
> comments while I debug. Suggestions of what's causing this are also
> welcome :)
>
> One of the major unresolved issues in the patch is what to do with the
> data in struct locale_mimo_info. The regulatory rules only hold one
> power level. I'm unsure why the brcmsmac implementation differs in this
> regard. Suggestions?
>
> The txpwr calculations are modified, both to use the regdomain data so
> far as possible and to eliminate redundant code. I'd appreciate review
> of these changes in addition to the suggestions on how to handle the
> MIMO power limits as I've already mentioned.
>
> Initialization has also changed somewhat. The piece that looks most
> significant to me is that wlc_phy_txpower_limit_set() gets called later,
> not until after the ieee80211_hw device is registered.
>
> Beyond these I still have a number of comments with my initials (SAF)
> that contain questions, comments, and TODOs. Feedback regarding these
> items, or anything else, are greatly appreciated.
>
> Looking forward to your comments.
>
> Thanks,
> Seth
>

Thanks, Seth

I am sure you are moving in the right direction here. Unfortunately, I 
am currently unable to give the patch a spin. I am attending the linux 
collaboration summit in San Francisco and I can only do some basic 
testing on it. I will be back in my office next week to do some more 
elaborate testing on it.

Gr. AvS

