Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1BXWOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:14:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608Ab1BXWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:14:16 -0500
Date: Thu, 24 Feb 2011 14:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
Message-Id: <20110224141335.978066c5.akpm@linux-foundation.org>
In-Reply-To: <20110224141034.d2dfb7de.akpm@linux-foundation.org>
References: <4D6419C0.8080804@redhat.com>
	<20110224141034.d2dfb7de.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 14:10:34 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 22 Feb 2011 21:17:04 +0100
> Petr Holasek <pholasek@redhat.com> wrote:
> 
> > When user insert negative value into /proc/sys/vm/nr_hugepages it will 
> > result
> > in the setting a random number of HugePages in system
> 
> Is this true?  afacit the kernel will allocate as many pages as it can
> and will then set /proc/sys/vm/nr_hugepages to reflect the result. 
> That's not random.
> 

Assuming the above to be correct, I altered the changelog thusly:

: When the user inserts a negative value into /proc/sys/vm/nr_hugepages it
: will cause the kernel to allocate as many hugepages as possible and to
: then update /proc/meminfo to reflect this.
:
: This changes the behavior so that the negative input will result in
: nr_hugepages value being unchanged.

and given that, I don't really see why we should change the existing behaviour.
