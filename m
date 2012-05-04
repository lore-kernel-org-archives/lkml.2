Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2EDSzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:55:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20983 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2EDSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:55:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
Subject: [RFC PATCH] Expand memblock=debug to provide a bit more details (v1).
Date: Fri,  4 May 2012 14:49:40 -0400
Message-Id: <1336157382-14548-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to track down some memory allocation issues, I realized that
memblock=debug was giving some information, but for guests with 256GB or
so the majority of it was just:

 memblock_reserve: [0x00003efeeea000-0x00003efeeeb000] __alloc_memory_core_early+0x5c/0x64

which really didn't tell me that much. With these patches I know it is:

 memblock_reserve: [0x00003ffe724000-0x00003ffe725000] (4kB) vmemmap_pmd_populate+0x4b/0xa2

.. which isn't really that useful for the problem I was tracking down, but
it does help in figuring out which routines are using memblock.

Please see the patches - not sure what is in the future for memblock.c
so if they are running afoul of some future grand plans - I can rebase them.

Thanks!
