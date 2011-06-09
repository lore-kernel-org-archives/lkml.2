Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1FIXAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:00:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab1FIW76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:59:58 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
 replacement.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 01:03:27 +0200
Message-ID: <1307660607.2497.1771.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> +       ret = anon_vma_prepare(vma);
> +       if (ret)
> +               goto unlock_out;

You just leaked new_page.

> +
> +       lock_page(new_page);
> +       ret = __replace_page(vma, old_page, new_page);
> +       unlock_page(new_page);
> +       if (ret != 0)
> +               page_cache_release(new_page);
> +unlock_out:
> +       unlock_page(old_page);
> +
> +put_out:
> +       put_page(old_page); /* we did a get_page in the beginning */
> +       return ret;
> +} 

