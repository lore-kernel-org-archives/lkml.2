Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2CHXFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:05:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2CHXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:05:07 -0500
Date: Thu, 8 Mar 2012 15:05:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@hack.frob.com>
Cc: Jason Baron <jbaron@redhat.com>, torvalds@linux-foundation.org,
        avi@redhat.com, cmetcalf@tilera.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] core dump: add VM_NODUMP, MADV_NODUMP,
 MADV_CLEAR_NODUMP
Message-Id: <20120308150505.c9c3d309.akpm@linux-foundation.org>
In-Reply-To: <20120308214417.328502C0C8@topped-with-meat.com>
References: <cover.1331238525.git.jbaron@redhat.com>
	<f52c6c288ec291c8cdc6176673d5b0d3d33a6f14.1331238525.git.jbaron@redhat.com>
	<20120308214417.328502C0C8@topped-with-meat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Mar 2012 13:44:17 -0800 (PST)
Roland McGrath <roland@hack.frob.com> wrote:

> I'm vaguely dubious about the desireability of using this new feature.
> (I would hate to try to debug a qemu bug from a dump where half the
> interesting state was intentionally hidden from me.)

yup.  But the dumpability is fully controllable by userspace: one can
easily envisage large vma's full of data which just isn't interesting
for a dump.  Plus if you're a developer who is looking at a dump and
important data isn't there, you can often delete one line, rebuild and
run the test again.  

>  But I don't see
> any problem with the implementation.
> 
> As to the interface, I think the bits are OK but it would be more
> in keeping with the existing MADV_* names to call the new values
> MADV_DONTDUMP and MADV_DODUMP.

Yup.  I queued a patch to do that.
