Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2IQGgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 02:36:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55309 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2IQGge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 02:36:34 -0400
Message-ID: <5056C4EC.1030305@gmail.com>
Date: Mon, 17 Sep 2012 08:36:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com> <20120916074652.GM28177@lunn.ch> <20120916124015.GI5469@titan.lakedaemon.net> <alpine.LFD.2.02.1209162137270.28681@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1209162137270.28681@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 03:55 AM, Nicolas Pitre wrote:
> On Sun, 16 Sep 2012, Jason Cooper wrote:
>> On Sun, Sep 16, 2012 at 09:46:52AM +0200, Andrew Lunn wrote:
>>>> +++ b/Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
>>>> @@ -0,0 +1,279 @@
>>>> +* Marvell Kirkwood SoC pinctrl driver for mpp
>>>> +
>>>> +Please refer to marvell,mvebu-pinctrl.txt in this directory for common binding
>>>> +part and usage.
>>>> +
>>>> +Required properties:
>>>> +- compatible: "marvell,88f6180-pinctrl",
>>>> +              "marvell,88f6190-pinctrl", "marvell,88f6192-pinctrl",
>>>> +              "marvell,88f6281-pinctrl", "marvell,88f6282-pinctrl"
>>>> +
>>>> +This driver supports all kirkwood variants, i.e. 88f6180, 88f619x, and 88f628
 >>> ...
>>> If i wanted to mass convert all existing kirkwood DT boards over to
>>> use pinctrl, im stuck at the very first step. I've no idea what chip
>>> they use, it was not relevant before.
>>
>> Let's try to do the DT correctly, and create a migration path for
>> kirkwood to work first, then migrate to using the DT fully.
>
> Beware beware.
>
> The DT should of course describe the hardware as accurately as possible.
> That doesn't necessarily mean it should describe the hardware as
> _extensively_ as possible.
>
> And that doesn't mean that all the information found in the DT has to be
> consumed by the kernel either.
>
> Any information that can be *probed* at run time has no benefit being
> stuffed in a DT.  That's true whether it is Linux or another operating
> system.  The more that can be probed at run time the better.

I had a closer look at how kirkwood probes its id. I mentionend kirkwood_id()
earlier but in fact it is kirkwood_pcie_id(). I assume pcie registers are shut
down with pcie clk gated? That would require to have pcie running at least at
boot-time on all boards.

While it is still possible to grab the id and power down pcie later, I still
think that using five different compatible strings is better here. Of course,
there is some effort to obtain the kirkwood SoC variant for all boards.

Sebastian




