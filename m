Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422879Ab2JDQbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:31:10 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46036 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441Ab2JDQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:31:06 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>, linux-mm@kvack.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, hannes@cmpxchg.org
Subject: Re: [PATCH 3/8] sparc64: Eliminate PTE table memory wastage.
In-Reply-To: <20121002.182642.49574627747120711.davem@davemloft.net>
References: <20121002.182642.49574627747120711.davem@davemloft.net>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
Date: Thu, 04 Oct 2012 22:00:48 +0530
Message-ID: <87y5jmfbd3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12100416-5140-0000-0000-00000229760B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> We've split up the PTE tables so that they take up half a page instead
> of a full page.  This is in order to facilitate transparent huge page
> support, which works much better if our PMDs cover 4MB instead of 8MB.
>
> What we do is have a one-behind cache for PTE table allocations in the
> mm struct.
>
> This logic triggers only on allocations.  For example, we don't try to
> keep track of free'd up page table blocks in the style that the s390
> port does.

I am also implementing a similar change for powerpc. We have a 64K page
size, and want to make sure PMD cover 16MB, which is the huge page size
supported by the hardware. I was looking at using the s390 logic,
considering we have 16 PMDs mapping to same PTE page. Should we look at
generalizing the case so that other architectures can start using the
same code ?

-aneesh

