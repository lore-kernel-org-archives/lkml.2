Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab2DFVBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:01:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41326 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2DFVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:01:44 -0400
Message-ID: <4F7F59B2.4090400@wwwdotorg.org>
Date: Fri, 06 Apr 2012 15:01:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        alan@linux.intel.com
Subject: Re: [PATCH 4/6] tegra, serial8250: add ->handle_break() uart_port
 op
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com> <20120406184956.22088.85217.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184956.22088.85217.stgit@dwillia2-linux.jf.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 12:49 PM, Dan Williams wrote:
> The "KT" serial port has another use case for a "received break" quirk,
> so before adding another special case to the 8250 core take this
> opportunity to push such quirks out of the core and into a uart_port op.

This doesn't seem quite right. Why do the board files have to set up
this .handle_break function; they're already setting .type=PORT_TEGRA,
which should be enough to drive the setup of any required quirks.

If plat_serial8250_port must contain this field, then
drivers/tty/serial/of_serial.c needs a similar change so that this all
works when booting using device tree.

I'm not sure what the implication is of moving the call to clr_fifo()
into uart_handle_break(). What's the benefit of one location over the other?

If the callback function is to no longer live in 8250.c itself,
arch/arm/mach-tegra/devices.c isn't logically a good place to put it,
and that file will be going away once we get rid of all the board files
and move solely to device tree.
