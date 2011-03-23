Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab1CWPUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:20:08 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57242 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932963Ab1CWPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:20:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EpuXzZWxSTVoBGd1WalSTzKeab875FVd3qBQN9ehUXE/RjoZDyLLz7rsmczoFD+SUIB8Xqo0HB59BodbD+hXQ7t5T6BeWwj6xb6+13Sz6ZJMCzjXqTV98s5tIVBBZBRC;
Date: Wed, 23 Mar 2011 08:20:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Subject: Re: [PATCH 1/2] staging: Add ST-Ericsson CG2900 driver
Message-Id: <20110323082002.bd60cea1.rdunlap@xenotime.net>
In-Reply-To: <1300888771-26437-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1300888771-26437-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 14:59:31 +0100 Par-Gunnar Hjalmdahl wrote:

> This patch adds support for the ST-Ericsson CG2900
> Connectivity Combo controller (Bluetooth, FM, GPS).
> 
> diff --git a/drivers/staging/cg2900/Kconfig b/drivers/staging/cg2900/Kconfig
> new file mode 100644
> index 0000000..d0ba5c7
> --- /dev/null
> +++ b/drivers/staging/cg2900/Kconfig
> @@ -0,0 +1,52 @@
> +#
> +# CG2900
> +#
> +
> +config CG2900
> +	tristate "Support ST-Ericsson CG2900 main structure"
> +	depends on NET && MFD_SUPPORT
> +	help
> +	  Support for ST-Ericsson CG2900 Connectivity Combo controller main structure.
> +	  Supports multiple functionalities muxed over a Bluetooth HCI H:4 interface.
> +	  CG2900 support Bluetooth, FM radio, and GPS.
> +
> +config CG2900_CHIP
> +	tristate "Support CG2900 Connectivity controller"
> +	depends on CG2900
> +	help
> +	  Support for ST-Ericsson CG2900 Connectivity Controller
> +
> +config STLC2690_CHIP
> +	tristate "Support STLC2690 Connectivity controller"
> +	depends on CG2900
> +	help
> +	  Support for ST-Ericsson STLC2690 Connectivity Controller
> +
> +config CG2900_UART
> +	tristate "Support CG2900 UART transport"
> +	depends on CG2900
> +	select BT
> +	select BT_HCIUART
> +	help
> +	  Support for UART as transport for ST-Ericsson CG2900 Connectivity
> +	  Controller
> +
> +config CG2900_AUDIO
> +	tristate "Support CG2900 audio interface"
> +	depends on CG2900
> +	help
> +	  Support for ST-Ericsson CG2900 Connectivity audio interface. Gives a
> +	  module the ability to setup audio paths within the CG2900 controller.
> +

Just to be clear:  the cg2900_audio driver does not use any current kernel
sound/audio interfaces, right?


> +config CG2900_TEST
> +	tristate "Support CG2900 Test Char Device"
> +	depends on CG2900
> +	help
> +	  Support for ST-Ericsson CG2900 Test Character Device.
> +
> +config BT_CG2900
> +	tristate "ST-Ericsson CG2900 Bluetooth driver"
> +	depends on CG2900 && BT
> +	help
> +	  Select if ST-Ericsson CG2900 Connectivity controller shall be used as
> +	  Bluetooth controller for BlueZ.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
