Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab1BKRHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:07:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788Ab1BKRHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:07:30 -0500
Date: Fri, 11 Feb 2011 18:07:22 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: disable identity mappings statically
Message-ID: <20110211170722.GA2010@jolsa.brq.redhat.com>
References: <1297432830-3912-1-git-send-email-jolsa@redhat.com>
 <m14o8a34em.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14o8a34em.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 08:46:41AM -0800, Eric W. Biederman wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > hi,
> >
> > while browsing the page table setup code, I noticed the x86_64 head
> > code might not need the identity mappings at all.
> > It seems it's ok to switch it off completely from the begining,
> > unless I'm missing something.
> 
> Have you tested it?

yes, I booted it with no problem

> 
> I expect you will find that we need the identity mapping because
> before we load this page table we are running with virt==phys
> and we need the identity mapping retained  in the new page table
> so we can get to the instruction after movq %rax, %cr0.

well, right after the page table setup, there's following code
switching to the kernel map adresses 0xffffffff80000000+

        movq    %rax, %cr3

        /* Ensure I am executing from virtual addresses */
        movq    $1f, %rax
        jmp     *%rax
1:


and I found no other identity mapping usage after this point

jirka
