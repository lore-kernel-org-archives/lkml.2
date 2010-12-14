Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab0LNQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308Ab0LNQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:31:09 -0500
Date: Tue, 14 Dec 2010 17:24:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 14/21] Create ELF header
Message-ID: <20101214162406.GG11400@redhat.com>
References: <20101214152259.67896960@suzukikp> <20101214154607.3ace278c@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214154607.3ace278c@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Suzuki K. Poulose wrote:
>
> +static void get_elfhdr_size(struct core_proc *cp)
> +{
> +	struct vm_area_struct *gate_vma;
> +	int segs;
> +
> +	segs = cp->task->mm->map_count;

But this is unsafe. What if cp->task was stopped when
open_gencore() was called? In this case it can be killed/dead.

cp->task->mm can be NULL. In fact, cp->task can point to nothing.

Any usage of cp->task is not safe, afaics.

Oleg.

