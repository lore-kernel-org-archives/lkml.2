Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1FSPPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:15:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34741 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1FSPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vC2Y7w8nGVAl19KJXRMUpnZue7qMCQQbL+V+Xrp0pMmJS0e0u2HMKWCkbwmyq4U1a1
         oixYSuq8/3Iri5FZrKXZJs6/yLM1shHNZ+W7u/F+Lxnt4nERiSnh7KgvPaeRtKzsXZMg
         vpSCRzh6QZBadDaf+9QyOAbFcBdf/TGdRcEpQ=
Message-ID: <4DFE129E.1010800@gmail.com>
Date: Sun, 19 Jun 2011 10:15:42 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@freescale.com>, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>	<1308410354-21387-2-git-send-email-shawn.guo@linaro.org>	<20110618161934.GH8195@ponder.secretlab.ca>	<20110619073000.GA23171@S2100-06.ap.freescale.net> <BANLkTi=1hf7ycwMBcZ0+VDNRMG1_vdnSqA@mail.gmail.com>
In-Reply-To: <BANLkTi=1hf7ycwMBcZ0+VDNRMG1_vdnSqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 10:05 AM, Grant Likely wrote:
> On Sun, Jun 19, 2011 at 1:30 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>> On Sat, Jun 18, 2011 at 10:19:34AM -0600, Grant Likely wrote:
>>> On Sat, Jun 18, 2011 at 11:19:12PM +0800, Shawn Guo wrote:
>>>> It adds device tree data parsing support for imx tty/serial driver.
>>>>
>>>> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
>>>> Signed-off-by: Jason Liu <jason.hui@linaro.org>
>>>> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>>>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>>>> ---
>>>>  .../bindings/tty/serial/fsl-imx-uart.txt           |   21 +++++
>>>>  drivers/tty/serial/imx.c                           |   81 +++++++++++++++++---
>>>>  2 files changed, 92 insertions(+), 10 deletions(-)
>>>>  create mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
>>>> new file mode 100644
>>>> index 0000000..7648e17
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
>>>> @@ -0,0 +1,21 @@
>>>> +* Freescale i.MX Universal Asynchronous Receiver/Transmitter (UART)
>>>> +
>>>> +Required properties:
>>>> +- compatible : should be "fsl,<soc>-uart", "fsl,imx-uart"
>>>
>>> I'd make this "fsl,<soc>-uart", "fsl,imx51-uart"
>>>
>>> It's better to anchor these things on real silicon, or a real ip block
>>> specification rather than something pseudo-generic.  Subsequent chips,
>>> like the imx53, should simply claim compatibility with the older
>>> fsl,imx51-uart.
>>
>> It is a real IP block on all imx silicons (except imx23 and imx28
>> which are known as former stmp).
>>
>>>
>>> (in essence, "fsl,imx51-uart" becomes the generic string without the
>>> downside of having no obvious recourse when new silicon shows up that
>>> is an imx part, but isn't compatible with the imx51 uart.
>>>
>> In this case, should imx1 the ancestor of imx family than imx51
>> becomes part of that generic string?  Claiming uart of imx1, imx21
>> and imx31 (senior than imx51) compatible with the imx51 uart seems
>> odd to me.
>>
>> That said, IMO, "fsl,imx-uart" stands a real IP block specification
>> here and can be a perfect generic compatibility string to tell the
>> recourse of any imx silicon using this IP.
> 
> Yes, but which /version/ of the IP block?  Hardware designers are
> notorious for changing hardware designs for newer silicon, sometimes
> to add features, sometimes to fix bugs.  While I understand the
> temptation to boil a compatible value down to a nice clean generic
> string, doing so only works in a perfect world.  In the real world,
> you still need to have some information about the specific
> implementation.  I prefer this specifying it to the SoC name, but I've
> been known to be convinced that specifying it to the ip-block name &
> version in certain circumstances, like for IP blocks in an FPGA, or
> some of the Freescale powerpc pXXXX SoCs which actually had an IP
> block swapped out midway through the life of the chip.
> 

There are definitely uart changes along the way with each generation.

> Besides, encoding an soc or ip block version into the 'generic'
> compatible values is not just good practice, it has *zero downside*.
> That's the beauty of the compatible property semantics.  Any node can
> claim compatibility with an existing device.  If no existing device
> fits correctly, then the node simple does not claim compatibility.
> Drivers can bind to any number of compatible strings, so it would be
> just fine for the of_match_table list to include both "fsl,imx-21" and
> "fsl,imx-51" (assuming that is the appropriate solution in this case).
> 

Don't you need uart or serial in here somewhere.

Rob
