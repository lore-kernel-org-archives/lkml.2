Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2GIKar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:30:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56331 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2GIKaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:30:46 -0400
Date: Mon, 9 Jul 2012 15:59:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] uprobes: kill
 write_opcode()->lock_page(new_page)
Message-ID: <20120709102952.GE32393@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120624145936.GA23269@redhat.com>
 <20120624150035.GC23277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120624150035.GC23277@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070910-6148-0000-0000-0000077A373F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-24 17:00:35]:

> write_opcode() does lock_page(new_page) for no reason. Nobody can
> see this page until __replace_page() exposes it under ptl lock, and
> we do nothing with this page after pte_unmap_unlock().
> 
> If nothing else, the similar code in do_wp_page() doesn't lock the
> new page for page_add_new_anon_rmap/set_pte_at_notify.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju<srikar@linux.vnet.ibm.com>

