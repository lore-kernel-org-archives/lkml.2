Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2KIUeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:34:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32939 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2KIUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:34:08 -0500
MIME-Version: 1.0
In-Reply-To: <A6697FB9-3614-4027-A71B-59C7556005BF@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
 <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
 <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com>
 <5ED17D42-07B8-4D4F-B54F-82B4CC60584C@antoniou-consulting.com>
 <509A3595.7050600@ti.com> <A6697FB9-3614-4027-A71B-59C7556005BF@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 20:33:47 +0000
X-Google-Sender-Auth: XqNIaZnyNNT8FpcJxCv8HRQrHog
Message-ID: <CACxGe6uXyTt_kr4=0ob+-ubgV9he+SfobLwux6X0m6y7yQU7EA@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 11:02 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> On Nov 7, 2012, at 11:19 AM, Benoit Cousson wrote:
>> Maybe some extra version match table can just be passed during the board machine_init
>>
>>       of_platform_populate(NULL, omap_dt_match_table, NULL, NULL, panda_version_match_table);
>>
>
> Would we need explicit of_platform_populate calls if we have node modification notifiers?
> In that case the notifier would pick it up automatically, and can do the per
> version matching internally.

There still needs to be something to register "everything below this
node is interesting" which is exactly what of_platform_populate() does
now. I see the notifiers being used by the of_platform_populate
backend to know when nodes have been created (or destroyed).

g.
