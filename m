Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2KLNBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:01:49 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34096 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2KLNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <AEFB103E-C71E-4A3C-B946-19ABD9025A17@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
 <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
 <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com>
 <5ED17D42-07B8-4D4F-B54F-82B4CC60584C@antoniou-consulting.com>
 <509A3595.7050600@ti.com> <A6697FB9-3614-4027-A71B-59C7556005BF@antoniou-consulting.com>
 <CACxGe6uXyTt_kr4=0ob+-ubgV9he+SfobLwux6X0m6y7yQU7EA@mail.gmail.com> <AEFB103E-C71E-4A3C-B946-19ABD9025A17@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 12 Nov 2012 13:01:27 +0000
X-Google-Sender-Auth: jwZD6yCAW9I66Ra1qD_ft3vTNtc
Message-ID: <CACxGe6sXnhFpGWG3Ak431=dnu0p-kFPLVDMfWLeyWE-ETeykKQ@mail.gmail.com>
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

On Mon, Nov 12, 2012 at 11:34 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Hi Grant,
>
> On Nov 9, 2012, at 10:33 PM, Grant Likely wrote:
>
>> On Wed, Nov 7, 2012 at 11:02 AM, Pantelis Antoniou
>> <panto@antoniou-consulting.com> wrote:
>>> On Nov 7, 2012, at 11:19 AM, Benoit Cousson wrote:
>>>> Maybe some extra version match table can just be passed during the board machine_init
>>>>
>>>>      of_platform_populate(NULL, omap_dt_match_table, NULL, NULL, panda_version_match_table);
>>>>
>>>
>>> Would we need explicit of_platform_populate calls if we have node modification notifiers?
>>> In that case the notifier would pick it up automatically, and can do the per
>>> version matching internally.
>>
>> There still needs to be something to register "everything below this
>> node is interesting" which is exactly what of_platform_populate() does
>> now. I see the notifiers being used by the of_platform_populate
>> backend to know when nodes have been created (or destroyed).
>>
>> g.
>
> I see. So of_platform_populate could just register the notifier and
> not do the tree walk itself. Perhaps the name is a bit misleading then?

Kind of, yes. of_platform_populate() would still have the same effect
that it does now except that it would also pay attention to additions
and removals from the DT nodes it is interested in. This would work
cleanly enough for node additions/removals, but it wouldn't process
changes to properties on existing nodes.

g.
