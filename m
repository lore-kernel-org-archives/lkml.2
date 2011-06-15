Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1FONPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:15:16 -0400
Received: from d1.icnet.pl ([212.160.220.21]:54804 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab1FONPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:15:15 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: balbi@ti.com
Subject: Re: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs entries
Date: Wed, 15 Jun 2011 15:14:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201106070316.41099.jkrzyszt@tis.icnet.pl> <201106151453.07945.jkrzyszt@tis.icnet.pl> <20110615130005.GM471@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110615130005.GM471@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151514.11574.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15 Jun 2011 at 15:00:08 Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jun 15, 2011 at 02:53:01PM +0200, Janusz Krzysztofik wrote:
> > 
> > $ grep -r "struct .* platform_device .* = {" .|grep "__initdata"|grep -v '*'
> > ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_kp_device __initdata = {
> > ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_lcd_device __initdata = {
> > ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_led_device __initdata = {
> > ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams_delta_camera_device __initdata = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_mpu_gpio = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio1 = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio2 = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio3 = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio4 = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio5 = {
> > ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device omap7xx_gpio6 = {
> > ./arch/arm/mach-omap1/gpio15xx.c:static struct __initdata platform_device omap15xx_mpu_gpio = {
> > ./arch/arm/mach-omap1/gpio15xx.c:static struct __initdata platform_device omap15xx_gpio = {
> > ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_mpu_gpio = {
> > ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio1 = {
> > ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio2 = {
> > ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio3 = {
> > ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device omap16xx_gpio4 = {
> > ./arch/arm/mach-omap2/board-rx51-peripherals.c:static struct platform_device rx51_si4713_dev __initdata_or_module = {
> > 
> > So, there is no single exact pattern found in the whole tree, and a
> > few instances of similiar patterns of two kinds found only inside
> > omap. If I follow any of the two, either moving '__initdata' in
> > front of 'platform_device' or using '__initdata_or_module'
> > instead, the problem no longer hits me (using my custom
> > defconfig). However, the former seems not conformant to what one
> > can learn from include/linux/init.h, so I suspect that placing
> > __initdata like this can be a noop, while the latter means "can be
> > init if no module support", which would probably still exhibit the
> > problem if so configured.
> > 
> > How would you like to have this corrected then?
> 
> I guess removing __initdata from all platoform_device structures is
> the way to go. We need to find another way to silent the section
> mismatch warnings.

OK. I'll cook a patch which removes __initdata from all listed above 
instead of only from board-ams-delta.

Thanks,
Janusz
