Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0CXOHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:07:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756339Ab0CXOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:07:05 -0400
Date: Wed, 24 Mar 2010 07:05:27 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, gregkh@suse.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 2/2] serial: Add driver for the Altera UART
Message-Id: <20100324070527.86d0b9b6.akpm@linux-foundation.org>
In-Reply-To: <20100324064747.GP21818@distanz.ch>
References: <cover.1267807169.git.klto@zhaw.ch>
	<15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch>
	<a596efa5dc6130a27d045ea24174c792ee2f0bb4.1267807169.git.klto@zhaw.ch>
	<20100323145459.9894b1e6.akpm@linux-foundation.org>
	<20100324064747.GP21818@distanz.ch>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 07:47:47 +0100 Tobias Klauser <tklauser@distanz.ch> wrote:

> On 2010-03-23 at 22:54:59 +0100, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri,  5 Mar 2010 17:52:23 +0100
> > Tobias Klauser <tklauser@distanz.ch> wrote:
> > 
> > > +	sigs |= (altera_uart_getppdcd(port->line) ? TIOCM_CD : 0);
> > > +	sigs |= (altera_uart_getppdtr(port->line) ? TIOCM_DTR : 0);
> > 
> > We seem to be missing a few things here.
> > 
> > drivers/serial/altera_uart.c: In function 'altera_uart_get_mctrl':
> > drivers/serial/altera_uart.c:100: error: implicit declaration of function 'altera_uart_getppdcd'
> > drivers/serial/altera_uart.c:101: error: implicit declaration of function 'altera_uart_getppdtr'
> > drivers/serial/altera_uart.c: In function 'altera_uart_set_mctrl':
> > drivers/serial/altera_uart.c:114: error: implicit declaration of function 'altera_uart_setppdtr'
> 
> These should usually be declared in a board specific header. There were
> compatibility macros in altera_uart.c which defined them to NOPs in case
> the board header did not properly define them. But I remove them as per
> request by Alan Cox (Message-ID: 20100301181920.3952c3e7@lxorguk.ukuu.org.uk).
> 
> Should we add them again (maybe to altera_uart.h)? Or would it be better
> to define a config symbol which is set in the board specific Kconfig and
> altera_uart depends on it?

I guess the latter.

There should have been a real implementation of these in the patchset -
otherwise the code can't be used or tested.  Confused.

