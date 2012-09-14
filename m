Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2INJ5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:57:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64203 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab2INJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:57:08 -0400
Date: Fri, 14 Sep 2012 10:57:02 +0100
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
Subject: Re: [PATCH 07/17] Documentation: Define the MSP Driver Device Tree
 bindings
Message-ID: <20120914095659.GQ3374@gmail.com>
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
 <1345816913-4113-8-git-send-email-lee.jones@linaro.org>
 <20120910164333.GB24506@gmail.com>
 <504EFF86.10105@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <504EFF86.10105@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:08:22AM +0200, Ola Lilja wrote:
> On 09/10/2012 06:43 PM, Lee Jones wrote:
> 
> > Ola poke.
> > 
> > On Fri, Aug 24, 2012 at 03:01:43PM +0100, Lee Jones wrote:
> >> Here we add the required documentation for the new Device Tree
> >> bindings pertaining to the MSP CPU-side DAI Driver.
> >> 
> >> CC: alsa-devel@alsa-project.org
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >> ---
> >>  .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++++++++++++++++++++
> >>  1 file changed, 43 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/sound/ux500-msp.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/sound/ux500-msp.txt b/Documentation/devicetree/bindings/sound/ux500-msp.txt
> >> new file mode 100644
> >> index 0000000..99acd9c
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/sound/ux500-msp.txt
> >> @@ -0,0 +1,43 @@
> >> +* ux500 MSP (CPU-side Digital Audio Interface)
> >> +
> >> +Required properties:
> >> + - compatible       :"stericsson,ux500-msp-i2s"
> >> + - reg              : Physical base address and length of the device's registers.
> >> +
> >> +Optional properties:
> >> + - interrupts       : The interrupt output from the device.
> >> + - interrupt-parent : The parent interrupt controller.
> >> + - <name>-supply    : Phandle to the regulator <name> supply
> >> +
> >> +Example:
> >> +
> >> +	sound {
> >> +		compatible = "stericsson,snd-soc-mop500";
> >> +
> >> +		stericsson,platform-pcm-dma = <&pcm>;
> >> +		stericsson,cpu-dai = <&msp1 &msp3>;
> >> +		stericsson,audio-codec = <&codec>;
> >> +	};
> >> +
> >> +	pcm: ux500-pcm {
> >> +		compatible = "stericsson,ux500-pcm";
> >> +	};
> >> +
> >> +	msp1: msp@80124000 {
> >> +		compatible = "stericsson,ux500-msp-i2s";
> >> +		reg = <0x80124000 0x1000>;
> >> +		interrupts = <0 62 0x4>;
> >> +		v-ape-supply = <&db8500_vape_reg>;
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
> This parameter has nothing to do with the ASoC platform-driver. Some way or the
> other the earpiece-cmv should belong to the codec-driver. Also, this parameter
> was set in the previous patch as well?!

You know that this is just a documentation patch right?

It just shows how the pieces fit together. No settings will actually
be read from here, it's just a .txt file used for reference.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
