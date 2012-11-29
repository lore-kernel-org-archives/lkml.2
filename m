Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2K2VEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:04:43 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63963 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2K2VEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:04:42 -0500
MIME-Version: 1.0
Date: Thu, 29 Nov 2012 16:04:40 -0500
Message-ID: <CAOGqxeUOrVFoqsmUV19h5tXsD6pw5creXP9aN1C-V7K3WL2EXA@mail.gmail.com>
Subject: MIPS Function Tracer question
From: Alan Cooper <alcooperx@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing some testing of the MIPS Function Tracer functionality
on the 3.3 kernel. I was surprised to find that the option to generate
frame pointers was required for tracing. When I don't enable
FRAME_POINTER along with FUNCTION_TRACER, the kernel hangs on boot. I
also noticed that a checkin to the 3.4 kernel
(b732d439cb43336cd6d7e804ecb2c81193ef63b0) no longer forces on
FRAME_POINTER when FUNCTION_TRACER is selected. I was wondering how it
works in 3.4 and beyond, so I built a Malta kernel from the latest
MIPS tree with FUNCTION_TRACING enabled and tested it with QEMU. The
kernel hung the same way. I can think of 2 reasons for this:
1. Function tracing is broken for MIPS in 3.4 and beyond.
2. The 4.5.3 GNU C compiler I'm using is generating different code for
function tracing.
I was wondering if anyone has MIPS function tracing working in 3.4 or later?

I did figure out why it's hanging and I have some changes that will
allow the function tracer to run without frame pointers, but before I
proceed I want to rule out compiler differences.

Thanks
