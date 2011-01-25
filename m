Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1AYPNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:13:51 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37895 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1AYPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:13:49 -0500
X-Sasl-enc: UALsj270sO0HwxX0pIol+FxDdW7N+6mtRoOguEsmVG7J 1295968429
Date: Tue, 25 Jan 2011 13:13:46 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: thinkpad-acpi: fn-f4 issues
Message-ID: <20110125151346.GB14803@khazad-dum.debian.net>
References: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc: trimmed down, as this is now a thinkpad-acpi matter)

On Tue, 25 Jan 2011, Jeff Chua wrote:
> As for the thinkpad-acpi, here a little patch to disable all hotkeys
> so that Fn-F4 works natively to suspend-to-memory when
> CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set.
> 
> Thanks,
> Jeff
> 
> --- lx/drivers/platform/x86/thinkpad_acpi.c.org	2011-01-22 21:48:05.000000000 +0800
> +++ lx/drivers/platform/x86/thinkpad_acpi.c	2011-01-22 21:55:14.000000000 +0800
> @@ -8776,10 +8776,12 @@
>  	{
>  		.data = &thinkpad_acpi_driver_data,
>  	},
> +#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
>  	{
>  		.init = hotkey_init,
>  		.data = &hotkey_driver_data,
>  	},
> +#endif

That will basicaly lobotomize the driver, as the "hotkeys" are really the
entire firmware event interface(!).

Which thinkpad do you have that need CONFIG_THINKPAD_ACPI_HOTKEY_POLL to
handle Fn+F4?   I don't expect that to be needed on anything newer than a
T32...

Can I have the full kernel log, please?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
