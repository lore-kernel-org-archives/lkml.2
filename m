Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1DYGBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 02:01:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab1DYGA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 02:00:59 -0400
Date: Sun, 24 Apr 2011 23:05:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Alfille <paul.alfille@gmail.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: w1 driver for omap error -- reversed byte sequence in netlink
 slave message
Message-Id: <20110424230536.a77c9366.akpm@linux-foundation.org>
In-Reply-To: <BANLkTimhyTLuKw90Q6HitVgLC7wyeOD5wQ@mail.gmail.com>
References: <BANLkTimhyTLuKw90Q6HitVgLC7wyeOD5wQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 21:53:39 -0400 Paul Alfille <paul.alfille@gmail.com> wrote:

> OWFS (one-wire filesystem -- www.owfs.org) seems to be the only user
> of the w1 netlink messages. We use them to extend the kernel 1-wire
> system from a simple temperature sensor to a complete 1-wire bus
> master. Thus we've uncovered a bug -- byte reversal -- in one of the
> sub-modules.
> 
> 1-wire devices have a unique 64-bit address (including an 8-bit CRC)
> that is reported by the netlink W1_CMD_SEARCH message. For the omap
> bus master, and only the omap bus master, the slave addresses are
> byte-order reversed. If the slave byte order is reversed in that case,
> the CRC8 is then correct, the slave address then matches the actual
> device address lettered on the device, and all other commands work
> correctly.
> 
> The driver is in kernel/drivers/w1/masters/omap_hdq.c
> 

Have you fixed it?  Can you send us a tested patch to look at?

Thanks.
