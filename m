Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1IAUhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:37:55 -0400
Received: from claw.goop.org ([74.207.240.146]:42651 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab1IAUhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:37:54 -0400
Message-ID: <4E5FED1A.1000300@goop.org>
Date: Thu, 01 Sep 2011 13:37:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Revert] Re: [PATCH] mm: sync vmalloc address space page tables
 in alloc_vm_area()
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com> <20110901161134.GA8979@dumpdata.com>
In-Reply-To: <20110901161134.GA8979@dumpdata.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 09:11 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Sep 01, 2011 at 12:51:03PM +0100, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
> Andrew,
>
> I was wondering if you would be Ok with this patch for 3.1.
>
> It is a revert (I can prepare a proper revert if you would like
> that instead of this patch).
>
> The users of this particular function (alloc_vm_area) are just
> Xen. There are no others.

I'd prefer to put explicit vmalloc_sync_all()s in the callsites where
necessary, and ultimately try to work out ways of avoiding it altogether
(like have some hypercall wrapper which touches the arg memory to make
sure its mapped?).

    J
