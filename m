Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2EJIde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:33:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39627 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab2EJIdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:33:31 -0400
Message-ID: <1336638422.2527.78.camel@twins>
Subject: Re: [PATCH v4 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 10:27:02 +0200
In-Reply-To: <1336626013-28413-7-git-send-email-alex.shi@intel.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
	 <1336626013-28413-7-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
> Not every flush_tlb_mm execution moment is really need to evacuate all
> TLB entries, like in munmap, just few 'invlpg' is better for whole
> process performance, since it leaves most of TLB entries for later
> accessing.
> 
> This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start, end)
> in cases.

No I thoroughly hate this patch. Please do something like:

 http://marc.info/?l=linux-arch&m=129952026504268&w=2

Afaict it achieves the same, doesn't mangle the tlb flush interfaces and
allows more arch to use generic code.
