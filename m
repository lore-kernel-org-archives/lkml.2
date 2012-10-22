Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2JVL4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:56:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33659 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2JVL4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:56:09 -0400
Date: Mon, 22 Oct 2012 14:55:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: re: sched, numa, mm: Implement constant, per task Working Set
 Sampling (WSS) rate
Message-ID: <20121022115545.GA631@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter Zijlstra,

The patch 3d049f8a5398: "sched, numa, mm: Implement constant, per
task Working Set Sampling (WSS) rate" from Oct 14, 2012, leads to the
following warning:
kernel/sched/fair.c:954 task_numa_work()
	 error: we previously assumed 'vma' could be null (see line 948)

   943          if (!vma) {
   944                  ACCESS_ONCE(mm->numa_scan_seq)++;
   945                  offset = 0;
   946                  vma = mm->mmap;
   947          }
   948          while (vma && !vma_migratable(vma)) {
                       ^^^
If this is NULL,
   949                  vma = vma->vm_next;
   950                  if (!vma)
   951                          goto again;
   952          }
   953  
   954          offset = max(offset, vma->vm_start);
                                     ^^^^^^^^^^^^^
then it leads to a NULL dereference here.

regards,
dan carpenter

