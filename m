Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2DFV46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:56:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53694 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2DFV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:56:57 -0400
Message-ID: <4F7F66A4.8070701@wwwdotorg.org>
Date: Fri, 06 Apr 2012 15:56:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        alan@linux.intel.com
Subject: Re: [PATCH 4/6] tegra, serial8250: add ->handle_break() uart_port
 op
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>	<20120406184956.22088.85217.stgit@dwillia2-linux.jf.intel.com>	<4F7F59B2.4090400@wwwdotorg.org> <CABE8wws23LSLBxz34LYuyYtXMCG+-YTShhojXdeVkfiOvHWseQ@mail.gmail.com>
In-Reply-To: <CABE8wws23LSLBxz34LYuyYtXMCG+-YTShhojXdeVkfiOvHWseQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 03:28 PM, Williams, Dan J wrote:
> On Fri, Apr 6, 2012 at 2:01 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 04/06/2012 12:49 PM, Dan Williams wrote:
>>> The "KT" serial port has another use case for a "received break" quirk,
>>> so before adding another special case to the 8250 core take this
>>> opportunity to push such quirks out of the core and into a uart_port op.
>>
>> This doesn't seem quite right. Why do the board files have to set up
>> this .handle_break function; they're already setting .type=PORT_TEGRA,
>> which should be enough to drive the setup of any required quirks.
> 
> Because struct serial8250_config does not convey any uart_port ops.

But couldn't it be enhanced to do so, just like this patch added a field
to struct uart_port for this? If you went this route, then the change
would be entirely isolated within 8250.c, so you could drop all the
arch/arm/mach-tegra changes, and also not need to update of_serial.c.

>> I'm not sure what the implication is of moving the call to clr_fifo()
>> into uart_handle_break(). What's the benefit of one location over the other?
> 
> This was the location where the core was already doing it's break
> handling, so it made sense to check here if the device had any quirks
> to run.  There shouldn't be any implications because the core was
> already doing clear_rx_fifo() immediately before calling
> uart_handle_break.  Here is the relevant hunk with a bit more context:

Ah OK, that part seems fine then.
