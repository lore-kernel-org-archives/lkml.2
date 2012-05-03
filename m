Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2ECNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:25:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40408 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2ECNZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAJDhSdc5J1xzvxYhvru6kjqAbq1NAtvWQCu-tXbi4aE_NXGXrg@mail.gmail.com>
References: <CAJDhSdc5J1xzvxYhvru6kjqAbq1NAtvWQCu-tXbi4aE_NXGXrg@mail.gmail.com>
Date: Thu, 3 May 2012 15:25:56 +0200
Message-ID: <CAJDhSdfd=k2VOO4X=vUUsSA1yFRHuFbwH67BuS6WiX3A6T2iMg@mail.gmail.com>
Subject: arcnet: protocol is buggy messages in 3.0 kernel, not in 2.33 kernel
From: Rob Janssen <rob.janssen76@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

Since we've moved from the 2.33 kernel to the 3.0 kernel, we see the
following kernel messages in dmesg:

protocol 001a is buggy, dev arc0 skb=c702e2f4

The device involved is an arcnet device.
The warning is logged by dev.c, see the following code snippet:

if (skb_network_header(skb2) < skb2->data ||
                           skb2->network_header > skb2->tail) {
                               if (net_ratelimit())
                                       printk(KERN_CRIT "protocol %04x is "
                                              "buggy, dev %s skb=%04x\n",
                                              ntohs(skb2->protocol),
                                              dev->name,
skb_network_header(skb2));
                               skb_reset_network_header(skb2);
                       }
I added some logging, and it appears that skb2->network_header is
placed in memory beyond skb2->tail (the second check).

Does anyone have what causes this message in the 3.0 kernel and/or how
to fix this ?

Thanks in advance,

Rob Janssen
