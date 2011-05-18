Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab1ERPEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:04:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:56014 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933223Ab1ERPEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:04:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,231,1304319600"; 
   d="scan'208";a="411455"
Date: Wed, 18 May 2011 15:50:33 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110518155033.2773b323@bob.linux.org.uk>
In-Reply-To: <20110518144429.GC2011@jolsa.brq.redhat.com>
References: <20110517231229.GB1776@nowhere>
	<20110518004420.2b8f5da9@bob.linux.org.uk>
	<20110518142631.GB2011@jolsa.brq.redhat.com>
	<20110518153636.5cdcdd78@lxorguk.ukuu.org.uk>
	<20110518144429.GC2011@jolsa.brq.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it's the 
> 
> uart_update_termios in uart_dtr_rts (drivers/tty/serial/serial_core.c)
> 
> called path:
> 
> tty_port_block_til_ready
> 	tty_port_raise_dtr_rts
> 		uart_dtr_rts
> 			uart_update_termios

Ah that would explain why I can't find and dup it - it isn't found in
the current -next tree.


c7d7abff40c27f82fe78b1091ab3fad69b2546f9 (and thereafter)

Jiri Slaby fixed it in sorting out uart_startup

I guess these should now get tagged for -stable.

