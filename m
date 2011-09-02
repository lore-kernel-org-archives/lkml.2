Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1IBXEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:04:24 -0400
Received: from claw.goop.org ([74.207.240.146]:45445 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab1IBXEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:04:22 -0400
Message-ID: <4E6160F3.8030708@goop.org>
Date: Fri, 02 Sep 2011 16:04:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Revert] Re: [PATCH] mm: sync vmalloc address space page tables
 in alloc_vm_area()
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com> <20110901161134.GA8979@dumpdata.com> <4E5FED1A.1000300@goop.org> <20110901141754.76cef93b.akpm@linux-foundation.org> <4E60C067.4010600@citrix.com> <20110902153204.59a928c1.akpm@linux-foundation.org>
In-Reply-To: <20110902153204.59a928c1.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 03:32 PM, Andrew Morton wrote:
> On Fri, 2 Sep 2011 12:39:19 +0100
> David Vrabel <david.vrabel@citrix.com> wrote:
>
>> Xen backend drivers (e.g., blkback and netback) would sometimes fail
>> to map grant pages into the vmalloc address space allocated with
>> alloc_vm_area().  The GNTTABOP_map_grant_ref would fail because Xen
>> could not find the page (in the L2 table) containing the PTEs it
>> needed to update.
>>
>> (XEN) mm.c:3846:d0 Could not find L1 PTE for address fbb42000
>>
>> netback and blkback were making the hypercall from a kernel thread
>> where task->active_mm != &init_mm and alloc_vm_area() was only
>> updating the page tables for init_mm.  The usual method of deferring
>> the update to the page tables of other processes (i.e., after taking a
>> fault) doesn't work as a fault cannot occur during the hypercall.
>>
>> This would work on some systems depending on what else was using
>> vmalloc.
>>
>> Fix this by reverting ef691947d8a3d479e67652312783aedcf629320a
>> (vmalloc: remove vmalloc_sync_all() from alloc_vm_area()) and add a
>> comment to explain why it's needed.
> oookay, I queued this for 3.1 and tagged it for a 3.0.x backport.  I
> *think* that's the outcome of this discussion, for the short-term?


Sure, that will get things going for now.

Thanks,
    J

