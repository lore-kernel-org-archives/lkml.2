Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1KQXf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:35:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1KQXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:35:28 -0500
Date: Thu, 17 Nov 2011 15:35:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, linux-arch@vger.kernel.org,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and
 HPAGE_SIZE
Message-Id: <20111117153526.f90ee248.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
	<alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 15:22:53 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> So, just remove the dummy and dangerous definitions since they are no
> longer needed and reveals the correct dependencies.  Tested on
> architectures using the definitions with allyesconfig: x86 (even with
> thp), hppa, mips, powerpc, s390, sh3, sh4, sparc, and sparc64, and
> with defconfig on ia64.

How could arch/mips/mm/tlb-r4k.c:local_flush_tlb_range() compile OK
with this change?

What that function is doing looks reasonable to me.  Why fill the poor
thing with an ifdef mess?

otoh, catching mistakes is good too.  Doing it at runtime as David
proposes is OK.

