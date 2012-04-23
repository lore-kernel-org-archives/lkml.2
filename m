Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2DWQlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:41:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54052 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2DWQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:41:45 -0400
Message-ID: <4F958645.4080200@wwwdotorg.org>
Date: Mon, 23 Apr 2012 10:41:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Poddar, Sourav" <sourav.poddar@ti.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCHv3 1/2] drivers: input: keypad: Add device tree support
References: <1335194839-30193-1-git-send-email-sourav.poddar@ti.com>	<4F95749E.40708@wwwdotorg.org> <CAKdam541af1bU8_64gTZva9VS0R3dTR=3L3J50o9HgHH+WaPYQ@mail.gmail.com>
In-Reply-To: <CAKdam541af1bU8_64gTZva9VS0R3dTR=3L3J50o9HgHH+WaPYQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 09:40 AM, Poddar, Sourav wrote:
> Hi Stephen,
> 
> On Mon, Apr 23, 2012 at 8:56 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 04/23/2012 09:27 AM, Sourav Poddar wrote:
>>> Update the Documentation with omap4 keypad device tree
>>> binding information.
>>> Add device tree support for omap4 keypad driver.
>>
>> Shouldn't this use the already-defined matrix keyboard bindings at
>> Documentation/devicetree/bindings/input/matrix-keymap.txt?
>>
> True, that is one way of describing the linux-keymap, but i think it can be
> done  either ways.

Well, there certainly is more than one way to represent the data.
However, it'd be best to avoid creating new bindings for every piece of
hardware when there's already an existing binding that can be used. By
reusing the binding, different HW can be configured in the same way thus
re-using any knowledge someone has of the binding.

> Are you hinting at getting rid of Documentation for each seperate modules and
> just use a single  Documentation/devicetree/bindings/input/matrix-keymap.txt?

You'd probably still need a device-specific binding in order to define
which compatible values were necessary, which reg values were necessary,
to reference the common binding documentation, to document any required
additional custom properties, and document any limitations. For example,
see how Olof wrote Documentation/devicetree/bindings/input/tegra-kbc.txt
based on the common matrix keyboard binding.
