Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1F0X67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:58:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6462 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab1F0X5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:57:35 -0400
Message-ID: <4E0918E9.2020802@cavium.com>
Date: Mon, 27 Jun 2011 16:57:29 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, linux-serial@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/7] serial/8250: I/O accessor cleanups
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2011 23:57:34.0839 (UTC) FILETIME=[FC367070:01CC3525]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 02:45 PM, Arnd Bergmann wrote:
> Hi Greg,
>
> This series of patches cleans up the part of the 8250 device
> driver that is responsible for accessing the hardware registers.
> The driver defines all sorts of methods to do that right now,
> when it really should only support memory mapped and programmed
> I/O by default, and the latter only on PC-compatible platforms
> including those that have ISA/PCMCIA/PCI buses.
>
> The series shrinks the 8250 driver by about 10% in both binary
> and source code size, hopefully with no loss of functionality,
> and it allows platforms to no longer define bogus inb/outb
> functions when they don't provide CONFIG_HAS_IOPORT. I've
> build-tested for x86 and ARM with and without HAS_IOPORT.
>
> Hopefully Ralf can provide some feedback about the three
> MIPS platforms that have code changed by this.
>
> 	Arnd
>
> Arnd Bergmann (7):
>    serial/8250: remove obsolete RM9000 port type
>    serial/8250: move alchemy I/O handler to platform code
>    serial/8250: move UPIO_TSI to powerpc
>    serial/8250: move DWAP support to arch/mips
>    serial/8250: remove obsolete and broken PORT_RSA support
>    serial/8250: sanitize fourport handling
>    serial/8250: make PIO support optional
>
>   arch/mips/Kconfig                         |    7 -
>   arch/mips/alchemy/common/platform.c       |   50 +++
>   arch/mips/pmc-sierra/msp71xx/msp_serial.c |   32 ++-
>   arch/powerpc/kernel/legacy_serial.c       |   24 ++
>   drivers/tty/serial/8250.c                 |  472 +++--------------------------
>   drivers/tty/serial/8250.h                 |    8 +
>   drivers/tty/serial/8250_hub6.c            |   17 +
>   drivers/tty/serial/Kconfig                |   15 -
>   drivers/tty/serial/serial_core.c          |    4 -
>   drivers/tty/serial/sunsu.c                |   93 ------
>   include/linux/serial.h                    |    2 +-
>   include/linux/serial_core.h               |   10 +-
>   include/linux/serial_reg.h                |   51 ---
>   13 files changed, 171 insertions(+), 614 deletions(-)
>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> Cc: linux-serial@vger.kernel.org
> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>


FWIW, this was basically the intention when I added the I/O accessor 
functions.

If you like you can add:

Acked-by: David Daney <david.daney@cavium.com>

