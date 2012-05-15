Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab2EOOhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:37:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2EOOhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:37:07 -0400
Message-ID: <1337092577.27694.45.camel@twins>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: Nick Piggin <npiggin@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Date: Tue, 15 May 2012 16:36:17 +0200
In-Reply-To: <4FB2590C.1050303@intel.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	 <4FB2590C.1050303@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 21:24 +0800, Alex Shi wrote:

> Sorry. I don't understand what's the comments Peter's made days ago. I should ask for more details originally. 
> 
> So, Peter, the correct change should like following, am I right?
> 
> -#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
> +#define tlb_flush(tlb, start, end) __flush_tlb_range((tlb)->mm, start, end)

No.. the correct change is to do range tracking like the other archs
that support flush_tlb_range() do.

You do not modify the tlb interface.

Again, see: http://marc.info/?l=linux-arch&m=129952026504268&w=2


