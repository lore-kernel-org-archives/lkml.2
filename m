Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0GIRav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:30:51 -0400
Received: from claw.goop.org ([74.207.240.146]:52898 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab0GIRau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:30:50 -0400
Message-ID: <4C375CC8.2030705@goop.org>
Date: Fri, 09 Jul 2010 10:30:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
References: <4C373AEC.6000502@goop.org> <20100709151211.GE13493@random.random> <4C37458B.8040408@goop.org> <20100709162255.GA5741@random.random>
In-Reply-To: <20100709162255.GA5741@random.random>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 09:22 AM, Andrea Arcangeli wrote:
> mmu notifier only relevant for userland mappings, not kernel
> mappings. I don't know about the xen use, but for vmalloc certainly it
> can't be a problem to remove those two mmu notifier invalidates.
>
> Only bit that is worrysome is the mm == &init_mm
> pte_alloc_kernel|pte_alloc_map_lock. That seems to imply it may also
> be used to mangle over userland. But apparently all users are passing
> &init_mm as expected. I guess if you remove the mm parameter and you
> default to &init_mm definitely there will be no risk in removing the
> mmu notifier range_start/end invalidates.
>   

No, we do have some users which use it on user memory.  But those users
are using it as part of their own mmu notifier backend, so the recursive
calls are causing a problem.  My point is that anyone using
apply_to_page_range should be making their own calls to mmu notifiers as
appropriate to whatever they're doing.

    J

