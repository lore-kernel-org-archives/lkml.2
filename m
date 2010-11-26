Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0KZIKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:10:53 -0500
Received: from claw.goop.org ([74.207.240.146]:56147 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab0KZIKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:10:52 -0500
Message-ID: <4CEF6B8B.8080206@goop.org>
Date: Fri, 26 Nov 2010 00:10:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Could we do immediate pte zaps in vunmap?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What if vm_unmap_ram() and co. immediately zeroed out the ptes, but
lazily deferred the tlb flushes?  It seems to me there's no benefit in
batching up the pte clearing since that can't be amortized like the tlb
flush.

I think that would solve the problem we have with the interactions
between lazy unmap and Xen.  The issue is having stray pte entries
around (because Xen keeps track of those as part of its page-type
mechanism), but stale tlb entries are no problem.

Thanks,
    J
