Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2CGVlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:41:08 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:60637 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2CGVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:41:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/lkml
Cc: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, cmetcalf@tilera.com
Subject: Re: [PATCH 1/2] core dump: drop VM_ALWAYSDUMP flag
In-Reply-To: Jason Baron's message of  Wednesday, 7 March 2012 16:19:09 -0500 <20120307211909.GB2409@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
	<3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com>
	<CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com>
	<20120307185035.GA2409@redhat.com>
	<20120307194302.7BD142C0C3@topped-with-meat.com>
	<20120307211909.GB2409@redhat.com>
X-Shopping-List: (1) Sensuous convulsions
   (2) Melodramatic deoxyribonucleic gongs
   (3) Androgynous revulsion dividers
   (4) Juvenile hootenanny exclusions
Message-Id: <20120307214104.7A4262C0C5@topped-with-meat.com>
Date: Wed,  7 Mar 2012 13:41:04 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=qe1nvlo_i8AA:10
		a=kj9zAlcOel0A:10 a=jd2QW2sFzpkr6RUvldAA:9 a=4UzDfMM6DJThQxqXAh4A:7
		a=CjuIK1q_8ugA:10 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few of the vDSO VM_ALWAYSDUMP cases have a comment about the core dump.
(It looks like they were all copied from my original comment in
arch/x86/vdso/vdso32-setup.c.)  So those should be removed where they are.
(You removed some of them, but not all.)  You should put that comment into
always_dump_vma.

get_gate_vma is always defined quite trivially, and is also the most
logically obvious case, so I would test it first.

It sounds like the Tile special case is unnecessary, so just
arch_vma_name(vma) != NULL is an adequate test.  Please give it
a clear comment about why that test makes sense, i.e. because all
extant uses are for a vDSO or something similar.


Thanks,
Roland
