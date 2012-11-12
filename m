Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2KLR0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:26:43 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59433 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2KLR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:26:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121104101327.GZ21164@n2100.arm.linux.org.uk>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-8-git-send-email-rabin@rab.in> <20121104101327.GZ21164@n2100.arm.linux.org.uk>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 12 Nov 2012 18:26:02 +0100
X-Google-Sender-Auth: siWQ6cLG67GzUZeZE4BM3pxI_HU
Message-ID: <CAH+eYFDzqEFZhomL-szRDY-J=DFp_XLBXYVf0ox_F-z=YdXP0A@mail.gmail.com>
Subject: Re: [PATCH 8/9] ARM: support uprobe handling
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, Jon Medhurst <tixy@yxit.co.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/4 Russell King - ARM Linux <linux@arm.linux.org.uk>
> On Sun, Oct 14, 2012 at 09:23:12PM +0200, Rabin Vincent wrote:
> > Extend the kprobes code to handle user-space probes.  Much of the code
> > can be reused so currently the ARM uprobes code reuses the kprobes
> > structures.  The decode tables are reused, with the modification that
> > for those instruction that require custom decoding for uprobes, a new
> > element is added in the table to specify a custom decoder function.
>
> How are accesses to userspace handled by the kprobes code?  Please point
> me to where these accesses are performed.

If you mean the accesses where we write the probe opcode, this is done
in write_opcode() in kernel/events/uprobes.c

If you instead mean the accesses which load/store instructions would
perform, this is done from userspace itself, by placing the modified
instruction in an executable area which is mapped to userspace, and
modifying the PC to point there.  See xol_get_insn_slot() in
kernel/events/uprobes.c
