Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2GIKcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:32:04 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59613 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab2GIKcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:32:01 -0400
Date: Mon, 9 Jul 2012 16:00:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] uprobes: don't recheck vma/f_mapping in
 write_opcode()
Message-ID: <20120709103032.GF32393@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120624145936.GA23269@redhat.com>
 <20120624150002.GA23277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120624150002.GA23277@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070910-1976-0000-0000-00000EFFAC9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-24 17:00:02]:

> write_opcode() rechecks valid_vma() and ->f_mapping, this is pointless.
> The caller, register_for_each_vma() or uprobe_mmap(), has already done
> these checks under mmap_sem.
> 
> To clarify, uprobe_mmap() checks valid_vma() only, but we can rely on
> build_probe_list(vm_file->f_mapping->host).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

