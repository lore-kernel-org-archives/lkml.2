Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0J0VEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:04:21 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:22619 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab0J0VES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:04:18 -0400
X-SpamScore: 1
X-BigFish: VS1(z3b68izzz1202hzzz2dh2a8h)
Message-ID: <4CC893CD.7020701@freescale.com>
Date: Wed, 27 Oct 2010 16:04:13 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Writing a console/tty driver -- how to use tty_port?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 21:04:44.0126 (UTC) FILETIME=[9467F7E0:01CB761A]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Do you have an updated version of Tiny TTY that uses tty_port structures?  I'm
trying to write a new TTY driver for a device that is not a UART, and I'm having
a hard time finding a good example.  I suspect I need to understand the tty_port
structure, but I can't find any documentation for it.

One specific problem I'm having is that I can't figure out how to get a
tty_struct pointer in my interrupt handler.  The ISR gets called whenever there
is new input, and it needs to call tty_insert_flip_string().  But it appears
that it's possible to have my driver opened multiple times, each time creating a
new TTY.  But since I can only have one interrupt handler, I don't know how to
determine which of the tty_structs to use.  I figure tty_port is a way to
resolve this problem, but I don't know how to use it exactly.

-- 
Timur Tabi
Linux kernel developer at Freescale

