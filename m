Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2DITsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:48:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47288 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2DITsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:48:16 -0400
Message-ID: <4F833CFC.9020809@wwwdotorg.org>
Date: Mon, 09 Apr 2012 13:48:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, ArndBergmannarnd@arndb.de,
        Grant Likely <grant.likely@secretlab.ca>, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v3 1/3] tegra, serial8250: add ->handle_break() uart_port
 op
References: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com> <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 01:48 PM, Dan Williams wrote:
> The "KT" serial port has another use case for a "received break" quirk,
> so before adding another special case to the 8250 core take this
> opportunity to push such quirks out of the core and into a uart_port op.
> 
> Stephen says:
> "If the callback function is to no longer live in 8250.c itself,
>  arch/arm/mach-tegra/devices.c isn't logically a good place to put it,
>  and that file will be going away once we get rid of all the board files
>  and move solely to device tree."
> 
> ...so since 8250_pci.c houses all the quirks for pci serial devices this
> quirk is similarly housed in of_serial.c.  Once the open firmware
> conversion completes the infrastructure details (CONFIG_TEGRA_SERIAL,
> include/linux/of_serial.h, and the export) can all be removed to make
> this self contained to of_serial.c.

This still seems much to invasive.

Again, what's wrong with simply keeping the quirk implementation where
it is, and driving everything off the already-extant
plat_serial8250_port.type == PORT_TEGRA flag?

I believe all that's required here is to enhance struct struct
serial8250_config (and hence 8250.c's uart_config[] quirk table) to be
able to set the quirk function pointers as well as all the other exiting
quirked variables.
