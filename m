Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0K2TGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:06:16 -0500
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:54887 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab0K2TGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:06:14 -0500
Date: Mon, 29 Nov 2010 20:05:46 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, gdb@sourceware.org, hellogcc@freelists.org
Subject: Re: [PATCH] Built kernel without -O2 option
Message-ID: <20101129190546.GA14255@host0.dyn.jankratochvil.net>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 04:56:15 +0100, Hui Zhu wrote:
> So I make a patch that add a option in "Kernel hacking" called "Close
> GCC optimization".  It will make kernel be built without -O2.

This seems to me as a workaround.  The real fix would be to use
	__attribute__((always_inline))
for functions requiring to be inlined and just compile everything with -O0 -g.

info '(gcc)Function Attributes'
`always_inline'
	Generally, functions are not inlined unless optimization is specified.
	For functions declared inline, this attribute inlines the function
	even if no optimization level was specified.

But `always_inline' has been discussed on linux-kernel million times.
I have not googled out a resolution why it is not applicable to this problem,
do you know why?


Thanks,
Jan
