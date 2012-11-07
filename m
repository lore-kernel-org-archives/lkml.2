Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2KGLCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:02:40 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:49510 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352Ab2KGLCi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:02:38 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <509A3595.7050600@ti.com>
Date: Wed, 7 Nov 2012 12:02:32 +0100
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <devicetree-discuss@lists.ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A6697FB9-3614-4027-A71B-59C7556005BF@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com> <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com> <5ED17D42-07B8-4D4F-B54F-82B4CC60584C@antoniou-consulting.com> <509A3595.7050600@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Nov 7, 2012, at 11:19 AM, Benoit Cousson wrote:

> Hi Panto,
> 
> On 11/07/2012 09:13 AM, Pantelis Antoniou wrote:
>> Hi Grant
>> 
>> On Nov 6, 2012, at 9:45 PM, Grant Likely wrote:
>> 
>>> On Tue, Nov 6, 2012 at 7:34 PM, Pantelis Antoniou
>>> <panto@antoniou-consulting.com> wrote:
>> 
>> [ snip ]
>>> 
>>> g.
>> 
>> Since we've started talking about longer term goals, and the versioning
>> provision seems to stand, I hope we address how much the fragment versioning
>> thing is similar to the way board revisions progress.
>> 
>> If a versioning syntax is available then one could create a single DT 
>> file for a bunch of 'almost' similar board and board revisions.
> 
> I even think that the version issue is probably much more important for the short term than the overlay aspect. Well at least as important. We start having as well a bunch a panda board version with different HW setup.
> 
> Having a single board-XXX.dts that will support all these versions is probably the best approach to avoid choosing that from the bootloader.
> 
> We need to figure out a format + mechanism compatible with the current non-versioned format to allow filtering the nodes at runtime to keep only the relevant one.
> 
> Something that can find the driver that will provide the proper board version or subsystem version or whatever like that:
> 
> 	compatible-version = "ti,panda-version", "panda";
> 
> Then at runtime we should create only the node with the correct match between the driver version and the string version.
> 
> 

This is exactly what we need. FWIW the capebus syntax is a little bit different.

> /* regular panda audio routing */
> sound: sound {
> 	compatible = "ti,abe-twl6040";
> 	ti,model = "PandaBoard";
> 	compatible-version = "ti,panda-version", "panda";
> 
> 	/* Audio routing */
> 	ti,audio-routing =
> 		"Headset Stereophone", "HSOL",
> 		"Headset Stereophone", "HSOR",
> 		"Ext Spk", "HFL",
> 		"Ext Spk", "HFR",
> 		"Line Out", "AUXL",
> 		"Line Out", "AUXR",
> 		"HSMIC", "Headset Mic",
> 		"Headset Mic", "Headset Mic Bias",
> 		"AFML", "Line In",
> 		"AFMR", "Line In";
> };
> 
> 
> /* Audio routing is different between PandaBoard4430 and PandaBoardES */
> &sound {
> 	ti,model = "PandaBoardES";
> 	compatible-version = "ti,panda-version", "panda-es";
> 
> 	/* Audio routing */
> 	ti,audio-routing =
> 		"Headset Stereophone", "HSOL",
> 		"Headset Stereophone", "HSOR",
> 		"Ext Spk", "HFL",
> 		"Ext Spk", "HFR",
> 		"Line Out", "AUXL",
> 		"Line Out", "AUXR",
> 		"AFML", "Line In",
> 		"AFMR", "Line In";
> };
> 

We use this syntax for capebus (totally non-standard of-course),

sound: sound {
	compatible = "ti,abe-twl6040";
	

	model@0 {
		ti,model = "PandaBoard";
		ti,audio-routing =
			"Headset Stereophone", "HSOL",
			"Headset Stereophone", "HSOR",
			"Ext Spk", "HFL",
			"Ext Spk", "HFR",
			"Line Out", "AUXL",
			"Line Out", "AUXR",
			"HSMIC", "Headset Mic",
			"Headset Mic", "Headset Mic Bias",
			"AFML", "Line In",
			"AFMR", "Line In";
	};

	model@1 {
		ti,model = "PandaBoardES";
		ti,audio-routing =
			"Headset Stereophone", "HSOL",
			"Headset Stereophone", "HSOR",
			"Ext Spk", "HFL",
			"Ext Spk", "HFR",
			"Line Out", "AUXL",
			"Line Out", "AUXR",
			"AFML", "Line In",
			"AFMR", "Line In";
	};

	/* common properties for either model */
};

The difference is that you don't get to repeat the common properties.

I don't know if this breaks any conventions but seems to work fine for our case.

> 
> Maybe some extra version match table can just be passed during the board machine_init 
> 
> 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL, panda_version_match_table);
> 

Would we need explicit of_platform_populate calls if we have node modification notifiers?
In that case the notifier would pick it up automatically, and can do the per
version matching internally.

> 
> Regards,
> Benoit  

Regards

-- Pantelis

