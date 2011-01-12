Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1ALPw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:52:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42736 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1ALPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:52:25 -0500
Date: Wed, 12 Jan 2011 15:52:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to
	setup.c
Message-ID: <20110112155215.GB11039@n2100.arm.linux.org.uk>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6> <20110111104051.GA11039@n2100.arm.linux.org.uk> <20110111153630.GB2707@angua.secretlab.ca> <20110111154833.GF11039@n2100.arm.linux.org.uk> <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 08:46:44AM -0700, Grant Likely wrote:
> Looks like I've hit a hiccup though.  When I remove the first call to
> __lookup_machine_type, then it is only called after the MMU is turned
> on and the kernel is no longer able to output the list of configured
> machine ids when it doesn't recognize the value in r1 (tested with
> qemu versatile emulation).  I'm still investigating, so I'll defer
> reposting the patch until I've got this issue solved.

It only does this when DEBUG_LL is enabled - at which point you have
printascii, printhex8, etc available (although there's no prototype
for them.)

You could use snprintf() to format a message and then use printascii()
(conditional on CONFIG_DEBUG_LL as the existing code does) as well as
printk("%s", buffer).  That means if you have a debugger you can dump
the kernel ring buffer and see the message, or see it via the serial
port/debugging channel if DEBUG_LL is enabled.
