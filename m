Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1A0WuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:50:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749Ab1A0WuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:50:22 -0500
Date: Thu, 27 Jan 2011 14:49:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash_dump: export is_kdump_kernel to modules,
 consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
Message-Id: <20110127144939.41b3ac39.akpm@linux-foundation.org>
In-Reply-To: <20110127105751.GB31360@aepfle.de>
References: <20110125161052.GA20105@aepfle.de>
	<20110127024352.GC20334@redhat.com>
	<20110127105751.GB31360@aepfle.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 11:57:51 +0100
Olaf Hering <olaf@aepfle.de> wrote:

> > Apart from that, moving the code from arch specific section to generic
> > code helps. So that bit you can retain and get rid of export of
> > is_kdump_kernel() and elfcorehdr_addr.
> 
> 
> Andrew, do you want a new patch with the export of elfcorehdr_addr
> removed, or can you edit my patch and remove that one line?

This?

--- a/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix
+++ a/kernel/crash_dump.c
@@ -18,7 +18,6 @@ unsigned long saved_max_pfn;
  * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
  */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-EXPORT_SYMBOL_GPL(elfcorehdr_addr);
 
 /*
  * elfcorehdr= specifies the location of elf core header stored by the crashed
_

