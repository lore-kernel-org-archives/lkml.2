Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0EFMrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 08:47:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34123 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988Ab0EFMr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 08:47:29 -0400
Message-ID: <4BE2BA55.6060109@mev.co.uk>
Date: Thu, 6 May 2010 13:47:17 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tobias Klauser <klto@zhaw.ch>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "nios2-dev@sopc.et.ntust.edu.tw" <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: [Nios2-dev] [PATCH 2/2] serial: Add driver for the Altera UART
References: <cover.1273048151.git.tklauser@distanz.ch>	<095aab012b2a6b3bbf4c7bc04294bb9c19316318.1273048151.git.tklauser@distanz.ch> <1273142684.3477.22.camel@gentoo-ija64.mev.local> <4BE2B02B.4010209@zhaw.ch>
In-Reply-To: <4BE2B02B.4010209@zhaw.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

On 06/05/10 13:03, Tobias Klauser wrote:
> I also noticed, that altera_uart_break_ctl takes the lock which might be
> not necessary as the caller in serial_core.c already takes port->mutex
> which should be enough. Or am I wrong?

It's not enough.  The spin lock is needed to protect modification of
pp->imr and writing this modified value to the control register.  Not
all paths that modify pp->imr and the control register grab port->mutex
beforehand (for example, the interrupt routine doesn't and can't).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
