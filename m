Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab0JYXx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:53:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24927 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0JYXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:53:27 -0400
Date: Mon, 25 Oct 2010 16:51:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 25 (acpi/apei-related)
Message-Id: <20101025165145.1b48cd69.randy.dunlap@oracle.com>
In-Reply-To: <20101025145834.9b68e026.sfr@canb.auug.org.au>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 14:58:34 +1100 Stephen Rothwell wrote:

> Hi all,

drivers/built-in.o: In function `herr_record_init':
(.text+0x85149): undefined reference to `trace_clock_local'
drivers/built-in.o: In function `herr_record_alloc':
(.text+0x851ab): undefined reference to `trace_clock_local'
drivers/built-in.o: In function `herr_record_alloc':
(.text+0x8521c): undefined reference to `trace_clock_local'


config ACPI_APEI
	bool "ACPI Platform Error Interface (APEI)"
	depends on X86
	select HERR_DEV_CORE

but kernel/trace/trace_clock is not built unless one of these symbols
is enabled:

obj-$(CONFIG_FUNCTION_TRACER) += trace/
obj-$(CONFIG_TRACING) += trace/
obj-$(CONFIG_X86_DS) += trace/
obj-$(CONFIG_RING_BUFFER) += trace/

and in this case, none of these is enabled.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
