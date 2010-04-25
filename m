Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0DYP4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:56:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:50370 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753194Ab0DYP4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:56:15 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/UkwkcFWPUG9xtIYvj8IgW2rGDqZDSsvk+lylPfT
	DXWGTRz666txDw
Message-ID: <4BD46619.5010701@gmx.de>
Date: Sun, 25 Apr 2010 17:56:09 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Harald Welte <laforge@gnumonks.org>, linux-kernel@vger.kernel.org,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA framebuffer
 driver
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>	<1271614873-5952-11-git-send-email-corbet@lwn.net>	<4BD20D56.7080402@gmx.de>	<20100423155725.7d3b2d2d@bike.lwn.net>	<4BD221E7.7060705@gmx.de>	<20100423165256.654ca5eb@bike.lwn.net>	<4BD22B96.5020102@gmx.de>	<4BD2CC46.4060908@gmx.de>	<20100424073359.349b4397@bike.lwn.net>	<20100424135316.GR24811@prithivi.gnumonks.org> <20100425083858.269bf0d8@bike.lwn.net>
In-Reply-To: <20100425083858.269bf0d8@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Jonathan Corbet schrieb:
> On Sat, 24 Apr 2010 15:53:16 +0200
> Harald Welte <laforge@gnumonks.org> wrote:
> 
>> Simply converting the original two busses to the new code is definitely
>> the way to go.  Maybe we'll keep the code for the other two around, but
>> somehow keep them inactive and don't advertise them unless somebody explicitly
>> does so?
> 
> OK, my proposal would be to add the following patch into the early part
> of the series; that will help to avoid the creation of confusion in the
> middle until the full i2c/gpio configuration code is in.
> 
> Look good?

Yes, it does. But it highlighted a bug in the original patch:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c11df2db>] i2c_transfer+0x19/0xb0
*pdpt = 000000000af77001 *pde = 0000000000000000
Oops: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/bind
Modules linked in: viafb(+) fbcon font bitblit softcursor fb 
i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer mmc_block 
rtl8187 snd eeprom_93cx6 soundcore via_sdmmc snd_page_alloc i2c_viapro 
ehci_hcd uhci_hcd mmc_core video output [last unloaded: viafb]

Pid: 3561, comm: insmod Tainted: G        W  2.6.34-rc5 #1 IL1/
EIP: 0060:[<c11df2db>] EFLAGS: 00010296 CPU: 0
EIP is at i2c_transfer+0x19/0xb0
EAX: 00000000 EBX: ffffffa1 ECX: 00000002 EDX: c74f2d68
ESI: db034294 EDI: c74f2d96 EBP: c74f2d60 ESP: c74f2d48
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process insmod (pid: 3561, ti=c74f2000 task=db022000 task.ti=c74f2000)
Stack:
  00000002 c74f2d68 c74f2d97 c74f2d96 c74f2d97 c74f2d96 c74f2d88 dc7308f0
<0> 00000040 c74f0001 c74f2d83 00010040 c74f0001 c74f2d96 00000001 00000000
<0> c74f2da4 dc733a7f c74f2d96 00002db0 dc738a28 db0349a8 c74f2e84 c74f2db0
Call Trace:
  [<dc7308f0>] ? viafb_i2c_readbyte+0x60/0x68 [viafb]
  [<dc733a7f>] ? viafb_lvds_identify_vt1636+0x38/0xbc [viafb]
  [<dc732a7f>] ? viafb_lvds_trasmitter_identify+0x2c/0x10d [viafb]
  [<dc7304cc>] ? viafb_init_chip_info+0x15b/0x23f [viafb]
  [<dc7340c3>] ? via_pci_probe+0x155/0x81c [viafb]
  [<c111f1c0>] ? idr_get_empty_slot+0x152/0x226
  [<c112e1ee>] ? pci_match_device+0xbf/0xca
  [<c112e09c>] ? local_pci_probe+0xe/0x10
  [<c112e71a>] ? pci_device_probe+0x43/0x66
  [<c1186374>] ? driver_probe_device+0x78/0x103
  [<c1186442>] ? __driver_attach+0x43/0x5f
  [<c1185d79>] ? bus_for_each_dev+0x3d/0x67
  [<c118624e>] ? driver_attach+0x14/0x16
  [<c11863ff>] ? __driver_attach+0x0/0x5f
  [<c11857f3>] ? bus_add_driver+0xa2/0x1d4
  [<c1186687>] ? driver_register+0x8b/0xeb
  [<c112e8fe>] ? __pci_register_driver+0x31/0x8a
  [<dc6f7000>] ? viafb_init+0x0/0x297 [viafb]
  [<dc6f7288>] ? viafb_init+0x288/0x297 [viafb]
  [<c1001133>] ? do_one_initcall+0x4b/0x130
  [<c1041ae9>] ? sys_init_module+0xa7/0x1de
  [<c1002750>] ? sysenter_do_call+0x12/0x26
Code: 8d 55 f8 89 4d fc b9 af f0 1d c1 e8 47 4c fa ff c9 c3 55 89 e5 57 
56 89 c6 53 bb a1 ff ff ff 83 ec 0c 89 55 ec 89 4d e8 8b 40 0c <83> 38 
00 0f 84 84 00 00 00 89 e0 25 00 f0 ff ff 8b 0d 68 5c 3a
EIP: [<c11df2db>] i2c_transfer+0x19/0xb0 SS:ESP 0068:c74f2d48
CR2: 0000000000000000

as you can see it is caused in viafb_lvds_trasmitter_identify by
-		viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
-		if (viafb_lvds_identify_vt1636()) {
+		if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_26)) {
which should rather be
-		viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
-		if (viafb_lvds_identify_vt1636()) {
+		if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_2C)) {
after which your patches including this work fine (on VX800 and CLE266).


Thanks,

Florian Tobias Schandinat

> viafb: Only establish i2c busses on ports that always had them
> 
> ...otherwise it seems we run into conflicts with shadowy other users which
> don't expect to see i2c taking control of ports it never used to do
> anything with.
> 
> Reported-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/video/via/via_i2c.c |   19 +++++++++++++------
>  drivers/video/via/via_i2c.h |    1 +
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
> index fe5535c..b5253e3 100644
> --- a/drivers/video/via/via_i2c.c
> +++ b/drivers/video/via/via_i2c.c
> @@ -170,13 +170,18 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
>  	return i2c_bit_add_bus(adapter);
>  }
>  
> +/*
> + * By default, we only activate busses on ports 2c and 31 to avoid
> + * conflicts with other possible users; that default can be changed
> + * below.
> + */
>  static struct via_i2c_adap_cfg adap_configs[] = {
> -	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26 },
> -	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31 },
> -	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25 },
> -	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c },
> -	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d },
> -	{ 0, 0, 0 }
> +	[VIA_I2C_ADAP_26]	= { VIA_I2C_I2C,  VIASR, 0x26, 0 },
> +	[VIA_I2C_ADAP_31]	= { VIA_I2C_I2C,  VIASR, 0x31, 1 },
> +	[VIA_I2C_ADAP_25]	= { VIA_I2C_GPIO, VIASR, 0x25, 0 },
> +	[VIA_I2C_ADAP_2C]	= { VIA_I2C_GPIO, VIASR, 0x2c, 1 },
> +	[VIA_I2C_ADAP_3D]	= { VIA_I2C_GPIO, VIASR, 0x3d, 0 },
> +	{ 0, 0, 0, 0 }
>  };
>  
>  int viafb_create_i2c_busses(struct viafb_par *viapar)
> @@ -189,6 +194,8 @@ int viafb_create_i2c_busses(struct viafb_par *viapar)
>  
>  		if (adap_cfg->type == 0)
>  			break;
> +		if (!adap_cfg->is_active)
> +			continue;
>  
>  		ret = create_i2c_bus(&i2c_stuff->adapter,
>  				     &i2c_stuff->algo, adap_cfg,
> diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
> index 00ed978..73d682f 100644
> --- a/drivers/video/via/via_i2c.h
> +++ b/drivers/video/via/via_i2c.h
> @@ -35,6 +35,7 @@ struct via_i2c_adap_cfg {
>  	enum via_i2c_type	type;
>  	u_int16_t		io_port;
>  	u_int8_t		ioport_index;
> +	u8			is_active;
>  };
>  
>  struct via_i2c_stuff {

