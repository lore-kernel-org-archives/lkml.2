Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab1GTL5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 07:57:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1GTL5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 07:57:07 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110719065350.GB1210@linux.vnet.ibm.com>
References: <20110617090504.GN4952@linux.vnet.ibm.com>
	 <1308303665.2355.11.camel@twins> <1308662243.26237.144.camel@twins>
	 <20110622143906.GF16471@linux.vnet.ibm.com>
	 <20110624020659.GA24776@linux.vnet.ibm.com>
	 <1308901324.27849.7.camel@twins>
	 <20110627064502.GB24776@linux.vnet.ibm.com> <1309165071.6701.4.camel@twins>
	 <20110718092055.GA1210@linux.vnet.ibm.com>
	 <1310999476.13765.107.camel@twins>
	 <20110719065350.GB1210@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 13:56:22 +0200
Message-ID: <1311162982.5345.47.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 12:23 +0530, Srikar Dronamraju wrote:
> > I don't think you can sell this, that'll make munmap() horridly slow.
> 
> Okay, 
> 
> How about using a counter and a wq in each vma.
> Based on the counter, I can wait in the munmap() and since this is per
> vma, this should be faster than srcu.
> 
> Counter would be incremented when we do a vma-rmap walk. 
> decremented when after insertion/deletion.
> read in munmap(). 

I know I would feel somewhat uneasy about growing struct vm_area_struct
for just uprobes, but what do other people think? 

Andrew, Christoph?
