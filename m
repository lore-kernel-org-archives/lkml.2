Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1LISGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:06:31 -0500
Received: from mx.binnacle.cx ([74.95.187.105]:30618 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1LISGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:06:30 -0500
Message-Id: <6.2.5.6.2.20111209130007.039b3078@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Fri, 09 Dec 2011 13:03:54 -0500
To: Stephen Hemminger <shemminger@vyatta.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>
From: starlight@binnacle.cx
Subject: Re: kernel 3.1.1 message:  <IRQ> warn_alloc_failed
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20111209095014.14a647cd@nehalam.linuxnetplumber.net
 >
References: <6.2.5.6.2.20111208210303.03a06228@flumedata.com>
 <20111209095014.14a647cd@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09:50 AM 12/9/2011 -0800, Stephen Hemminger wrote:
>On Thu, 08 Dec 2011 21:10:02 -0500 starlight@binnacle.cx wrote:
>
>You are seeing memory allocation failures because device
>is allocating a 16K (order 2) size socket buffer. You are using
>netxen device, and it looks like the problem.
>
>From reading the netxen driver source. The LRO buffers
>in this device are very large (8060+skb overhead).
>Until the driver is fixed to use fragmented page size memory,
>I recommend turning off LRO.

Thank you for the analysis.  As an alternative
would it make sense to double or quadruple

    /proc/sys/vm/min_free_kbytes

or perhaps do the same for

    /proc/slabinfo(size-16384)

or both?

