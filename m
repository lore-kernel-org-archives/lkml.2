Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0IGNJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab0IGNJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:09:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Andy Whitcroft <apw@canonical.com>
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: checkpatch problem
Date: Tue, 07 Sep 2010 14:09:42 +0100
Message-ID: <23323.1283864982@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Checkpatch generates the following messages for inline asm strings:

WARNING: unnecessary whitespace before a quoted newline
#49: FILE: arch/m32r/include/asm/irqflags.h:31:
+               "ld24   %0, #0  ; Use 32-bit insn.                      \n\t"

however, inline asm is more readable if I can tabulate things, including the
newline markers:

	asm volatile (
		"ld24	%0, #0	; Use 32-bit insn.			\n\t"
		"mvfc	%1, psw	; No interrupt can be accepted here.	\n\t"
		"mvtc	%0, psw						\n\t"
		"and3	%0, %1, #0xffbf					\n\t"
		"mvtc	%0, psw						\n\t"
		: "=&r" (tmpreg0), "=&r" (tmpreg1)
		:
		: "cbit", "memory");

Can you please fix it, even if it's only to permit multiple TAB chars before
'\n'.

Whilst this check is probaly fine for strings to be displayed in some way, this
doesn't necessarily apply to inline asm strings.  Furthermore, the extra white
space does not impact the resulting binary.

David
