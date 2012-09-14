Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2INKDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:03:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37321 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2INKDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:03:02 -0400
Date: Fri, 14 Sep 2012 11:02:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ola Lilja <ola.o.lilja@stericsson.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Roger NILSSON1 <roger.xr.nilsson@stericsson.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 06/17] Documentation: Define the MOP500 Audio Machine
 Driver Device Tree bindings
Message-ID: <20120914100254.GR3374@gmail.com>
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
 <1345816913-4113-7-git-send-email-lee.jones@linaro.org>
 <20120910164413.GC24506@gmail.com>
 <504EFEF8.6020707@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <504EFEF8.6020707@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:06:00AM +0200, Ola Lilja wrote:
> On 09/10/2012 06:44 PM, Lee Jones wrote:
> 
> > Ola poke.
> > 
> > On Fri, Aug 24, 2012 at 03:01:42PM +0100, Lee Jones wrote:
> >> Here we add the required documentation for the new Device Tree
> >> bindings pertaining to the MOP500 Audio Machine driver.
> >> 
> >> CC: alsa-devel@alsa-project.org
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >> ---
> >>  .../devicetree/bindings/sound/ux500-mop500.txt     |   39 ++++++++++++++++++++
> >>  1 file changed, 39 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/sound/ux500-mop500.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/sound/ux500-mop500.txt b/Documentation/devicetree/bindings/sound/ux500-mop500.txt
> >> new file mode 100644
> >> index 0000000..48e071c
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/sound/ux500-mop500.txt
> >> @@ -0,0 +1,39 @@
> >> +* MOP500 Audio Machine Driver
> >> +
> >> +This node is responsible for linking together all ux500 Audio Driver components.
> >> +
> >> +Required properties:
> >> + - compatible              : "stericsson,snd-soc-mop500"
> >> +
> >> +Non-standard properties:
> >> + - stericsson,cpu-dai      : Phandle to the CPU-side DAI
> >> + - stericsson,audio-codec  : Phandle to the Audio CODEC
> >> + - stericsson,card-name    : Over-ride default card name
> >> +
> >> +Example:
> >> +
> >> +	sound {
> >> +		compatible = "stericsson,snd-soc-mop500";
> >> +
> >> +		stericsson,cpu-dai = <&msp1 &msp3>;
> >> +		stericsson,audio-codec = <&codec>;
> >> +	};
> >> +
> >> +	msp1: msp@80124000 {
> >> +		compatible = "stericsson,ux500-msp-i2s";
> >> +		reg = <0x80124000 0x1000>;
> >> +		interrupts = <0 62 0x4>;
> >> +		v-ape-supply = <&db8500_vape_reg>;
> 
> 
> I'm no DT-expert, but why are you adding MSP-stuff in the machine-driver? They
> are also added in the next patch.

This is a documentation file. Duplication is not important, as it's only there
for reference.

> >> +	};
> >> +
> >> +	msp3: msp@80125000 {
> >> +		compatible = "stericsson,ux500-msp-i2s";
> >> +		reg = <0x80125000 0x1000>;
> >> +		interrupts = <0 62 0x4>;
> >> +		v-ape-supply = <&db8500_vape_reg>;
> >> +	};
> >> +
> >> +	codec: ab8500-codec {
> >> +		compatible = "stericsson,ab8500-codec";
> >> +		stericsson,earpeice-cmv = <950>; /* Units in mV. */
> 
> 
> Only four voltages are allowed here. Maybe enumerate them in the comment?

This isn't the ab8500-codec documentation. For valid earpiece values please
see the documentation in patch "Documentation: Add the AB8500 CODEC device
to the MFD AB8500 doc"

Apart from these comments does the patch looks okay?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
