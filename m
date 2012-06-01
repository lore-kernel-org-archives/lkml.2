Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714Ab2FASyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab2FASya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:54:30 -0400
Date: Fri, 1 Jun 2012 20:52:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Subject: Re: [RESEND PATCH 1/3] uprobes: Remove redundant
	lock_page/unlock_page
Message-ID: <20120601185237.GC31771@redhat.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com> <1338465518.28384.55.camel@twins> <20120531150756.GC24279@linux.vnet.ibm.com> <1338483372.28384.65.camel@twins> <20120601091950.GF24279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601091950.GF24279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Srikar Dronamraju wrote:
>
> @@ -315,12 +315,10 @@ static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_
>  	if (ret <= 0)
>  		return ret;
>
> -	lock_page(page);
>  	vaddr_new = kmap_atomic(page);
>  	vaddr &= ~PAGE_MASK;
>  	memcpy(opcode, vaddr_new + vaddr, UPROBE_SWBP_INSN_SIZE);
>  	kunmap_atomic(vaddr_new);
> -	unlock_page(page);

Great, this lock_page() was really confusing.

Oleg.

