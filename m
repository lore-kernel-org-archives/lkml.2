Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2HBSEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:04:05 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:38855 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2HBSED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:04:03 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: viafb on Clevo M5x0V laptop (+VT1631L)
Date: Thu, 2 Aug 2012 20:03:27 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201208022003.28404.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I've got a Clevo M5x0V laptop which has VIA PM800 chipset (1106:3118) and 
1280x768 LCD panel connected using VT1631L LVDS transmitter. There's a 
schematic of this laptop available on the web which shows that VT1631L's I2C 
port is not connected anywhere...

viafb does not work properly - LCD panel (and backlight) is turned off upon 
module load and there's 640x480 signal on VGA connector (even when monitor 
was not connected during module load).

Looking at the code, there's almost nothing for VT1631. What needs to be done 
in order for the LCD to work? Xorg seems to work using openchrome (but it is 
not able to restore the card on resume from S3):
(II) CHROME(0): Unable to get panel size from EDID. Return code: 0
(II) CHROME(0): ViaPanelGetNativeModeFromScratchPad
(II) CHROME(0): Native Panel Resolution is 1280x768


This is from kernel 3.5 with VIAFB_DEBUG and VIAFB_WARN enabled:

[  153.051061] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[  153.051765] viafb 0000:01:00.0: power state changed by ACPI to D0
[  153.051773] viafb 0000:01:00.0: power state changed by ACPI to D0
[  153.053535] Device ID = 3259
[  153.053553] FB Size = 4000
[  153.059984] VIAFB PCI Probe!!
[  153.060044] viafb: Probing I2C bus 0x26
[  153.092761] viafb: Probing I2C bus 0x31
[  155.588019] viafb: Probing I2C bus 0x2C
[  155.619016] viafb: Finished I2C bus probing
[  155.619021] parse_lcd_port: viafb_lcd_port:,interface:0
[  155.619023] parse_dvi_port: viafb_dvi_port:,interface:0
[  155.713224] TMDS Chip = 0
[  155.713227] viafb_init_dvi_size()
[  155.713229] viafb_dvi_sense!!
[  155.714415] viafb_dvi_query_EDID!!
[  155.716820] viafb_dvi_query_EDID!!
[  155.719179] viafb_lvds_identify_vt1636.
[  155.812018] viafb_lvds_identify_vt1636.
[  155.814383] viafb_init_lcd_size()
[  155.814384] fp_get_panel_id()
[  155.814387] LVDS Chip = 0
[  155.814389] LVDS1 output_interface = 6
[  155.814391] LVDS2 output_interface = 6
[  155.814405] viafb_check_var!
[  155.815250] fbcon: Via (fb0) is primary device
[  155.815257] viafb_open!
[  155.818608] viafb_set_par!
[  155.818720] via_set_primary_pitch(0x00000A00)
[  155.818723] via_set_secondary_pitch(0x00000A00)
[  155.818727] via_set_primary_color_depth(24)
[  155.818730] via_set_secondary_color_depth(24)
[  155.818788] viafb_pan_display, address = 0
[  155.818789] via_set_primary_address(0x00000000)
[  155.818793] via_set_secondary_address(0x00000000)
[  155.819020] viafb_pan_display, address = 0
[  155.819021] via_set_primary_address(0x00000000)
[  155.819025] via_set_secondary_address(0x00000000)
[  155.819044] viafb 2D engine: imageblit
...many imageblits...
[  155.826516] Console: switching to colour frame buffer device 80x30
[  155.826522] viafb_pan_display, address = 0
[  155.826523] via_set_primary_address(0x00000000)
[  155.826527] via_set_secondary_address(0x00000000)
...many imageblits...
[  155.833889] fb0: Via frame buffer device 640x480-32bpp


-- 
Ondrej Zary
