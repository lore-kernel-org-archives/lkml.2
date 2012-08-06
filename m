Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2HFXai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:30:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41288 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543Ab2HFXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:30:36 -0400
X-Sasl-enc: bC1+sfXCrJVySR1yyohtsgP9jk6N566oxWfGmb9GdIvG 1344295835
Date: Mon, 6 Aug 2012 20:30:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: manoj.iyer@canonical.com
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        mjg@redhat.com, ibm-acpi@hmh.eng.br,
        platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: recognize latest
 V-Series using DMI_BIOS_VENDOR
Message-ID: <20120806233030.GA21032@khazad-dum.debian.net>
References: <1344294937-19338-1-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344294937-19338-1-git-send-email-manoj.iyer@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2012, manoj.iyer@canonical.com wrote:
> In the latest V-series bios DMI_PRODUCT_VERSION does not contain
> the string Lenovo or Thinkpad, but is set to the model number, this
> causes the thinkpad_acpi module to fail to load. Recognize laptop
> as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.
> 
> Test on V490u
> =============
> == After the patch ==
> 
> [ 1350.295757] thinkpad_acpi: ThinkPad ACPI Extras v0.24
> [ 1350.295760] thinkpad_acpi: http://ibm-acpi.sf.net/
> [ 1350.295761] thinkpad_acpi: ThinkPad BIOS H7ET21WW (1.00 ), EC unknown
> [ 1350.295763] thinkpad_acpi: Lenovo LENOVO, model LV5DXXX
> [ 1350.296086] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> [ 1350.296694] thinkpad_acpi: radio switch found; radios are enabled
> [ 1350.296703] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
> [ 1350.306466] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [ 1350.307082] Registered led device: tpacpi::thinklight
> [ 1350.307215] Registered led device: tpacpi::power
> [ 1350.307255] Registered led device: tpacpi::standby
> [ 1350.307294] Registered led device: tpacpi::thinkvantage
> [ 1350.308160] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [ 1350.308333] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [ 1350.312287] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input14
> 
> == Before the patch ==
> sudo modprobe thinkpad_acpi
> FATAL: Error inserting thinkpad_acpi (/lib/modules/3.2.0-27-generic/kernel/drivers/platform/x86/thinkpad_acpi.ko): No such device
> 
> Test on B485
> =============
> This patch was also test in a B485 where the thinkpad_acpi module does not
> have any issues loading. But, I tested it to make sure this patch does not
> break on already functioning models of Lenovo products.
> 
> [13486.746359] thinkpad_acpi: ThinkPad ACPI Extras v0.24
> [13486.746364] thinkpad_acpi: http://ibm-acpi.sf.net/
> [13486.746368] thinkpad_acpi: ThinkPad BIOS HJET15WW(1.01), EC unknown
> [13486.746373] thinkpad_acpi: Lenovo Lenovo LB485, model 814TR01
> [13486.747300] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> [13486.752435] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [13486.752883] Registered led device: tpacpi::thinklight
> [13486.752915] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [13486.753216] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [13486.757147] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input15
> 
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
