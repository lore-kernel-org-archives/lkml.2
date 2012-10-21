Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2JUAGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 20:06:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38791 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2JUAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 20:06:34 -0400
Date: Sat, 20 Oct 2012 17:06:29 -0700
From: Tom Rini <trini@ti.com>
To: Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: stable@kernel.org
Subject: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on boot
Message-ID: <20121021000629.GA2835@bill-the-cat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I grabbed 3.7-rc2 and found the following on boot:
PANIC: early exception 08 rip 246:10 error 81441d7f cr2 0

A git bisect says that this problems came from:
1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a is the first bad commit
commit 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a
Author: Jacob Shin <jacob.shin@amd.com>
Date:   Thu Oct 20 16:15:26 2011 -0500

    x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
    
    On systems with very large memory (1 TB in our case), BIOS may report a
    reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
    these from the direct mapping.


The box in question is an Asus motherboard with AMD Phenom(tm) II X6
1100T and 16GB memory.  Happy to provide any other information required.

-- 
Tom
