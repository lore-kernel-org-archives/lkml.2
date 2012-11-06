Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2KFWSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:18:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50265 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2KFWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:18:02 -0500
Message-ID: <50998C96.9090601@wwwdotorg.org>
Date: Tue, 06 Nov 2012 15:17:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Russ Dill <Russ.Dill@ti.com>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <20121106183531.GH6801@atomide.com> <CA+Bv8XZOt7h3dtDsk1SaR71J3tYFOTsPJSjZLSP3RVuLdYdFDg@mail.gmail.com> <56051C08-3ECF-4C0A-9B88-64B4C1DDDF45@antoniou-consulting.com>
In-Reply-To: <56051C08-3ECF-4C0A-9B88-64B4C1DDDF45@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 12:41 PM, Pantelis Antoniou wrote:
> Hi Russ,
> 
> On Nov 6, 2012, at 8:29 PM, Russ Dill wrote:
> 
>> On Tue, Nov 6, 2012 at 10:35 AM, Tony Lindgren <tony@atomide.com> wrote:
>>> * Grant Likely <grant.likely@secretlab.ca> [121106 03:16]:
>>>> On Tue, Nov 6, 2012 at 10:30 AM, Pantelis Antoniou
>>>> <panto@antoniou-consulting.com> wrote:
>>>>>
>>>>> Another can of worms is the pinctrl nodes.
>>>>
>>>> Yes... new pinctrl data would need to trigger adding new data to
>>>> pinctrl. I don't know if the pinctrl api supports that.
>>>
>>> The actual pins stay the same, just their configuration
>>> changes. AFAIK all that is already supported using the
>>> pinctrl framework.
>>>
>>> For example, considering hotplugging capes on the beaglebone:
...
>> That assumes that for a particular external bus, certain pins aren't
>> already shared with functions already on the board, for instance if an
>> I²C bus brought out to the external bus already has a chip connected
>> to it.
> 
> This is our case on the bone. We don't enable the peripheral until
> a cape that references it is enabled.
> 
> I don't think that very big changes are going to be needed TBH.
...
> Ideally if we could do this in the cape definition:
> 
> 	cape_pinmux {
> 		parent = <&am3358_pinmux>;

I think the cape overlay would simply add nodes to the existing pin
controller node, so I'd presume you would replace the two lines
immediately above with:

am3358_pinmux: pinmux {

> 
>                 bone_dvi_cape_led_pins: pinmux_bone_dvi_cape_led_pins {
>                         pinctrl-single,pins = <
>                                 0x48 0x07       /* gpmc_a2.gpio1_18, OUTPUT | MODE7 */
>                                 0x4c 0x07       /* gpmc_a3.gpio1_19, OUTPUT | MODE7 */
>                         >;
> 	};
> 
>         pinctrl-0 = <&bone_geiger_cape_pins>;

