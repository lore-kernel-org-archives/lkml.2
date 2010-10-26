Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab0JZCxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0JZCxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:11 -0400
Subject: [PATCH 00/43] MN10300: Add SMP support and AM34 CPU core support
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:53:02 +0100
Message-ID: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These patches support for the AM34 CPU core variant of the MN10300 arch.  This
is an SMP capable core, so SMP support is added also.

Further, support for the MN2WS0060 processor (which is AM34 based), and the
ASB2364 evaluation board are added to make use of that.

I've placed the SMP caching and TLB code into preliminary patches (#15-#24 and
#26-#29) within the series, though the code in them can't be fully utilised
until the main SMP patch (#35) is applied.  This makes the main SMP cache patch
smaller.  Similarly, patches for kernel atomic ops (#31) and SMP FPU support
(#30) preface the main patch.

There are a couple of patches here that touch code outside of the arch:

 (#1) A patch to revert parenthesisation of numbers in asm-offset.h which
      breaks the MN10300 assembly code.

 (#6) A patch to typedef the smpcall function pointer as it's used in many
      places.

(#36) Some changes to the SMSC 911x driver to provide it with hooks by which it
      can manipulate the interrupt regs on the ASB2364 board FPGA and find the
      MAC address in an alternate location.

David
