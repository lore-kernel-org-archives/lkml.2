Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2IHIjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:39:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55880 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2IHIjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120906222933.GR2448@linux.vnet.ibm.com>
References: <5044692D.7080608@linux.vnet.ibm.com>
	<5046B9EE.7000804@linux.vnet.ibm.com>
	<0000013996b6f21d-d45be653-3111-4aef-b079-31dc673e6fd8-000000@email.amazonses.com>
	<504812E7.3000700@linux.vnet.ibm.com>
	<20120906222933.GR2448@linux.vnet.ibm.com>
Date: Sat, 8 Sep 2012 11:39:14 +0300
X-Google-Sender-Auth: n8Q23k7bKubHkpxcesqjLET3eYw
Message-ID: <CAOJsxLFA1sk4KZkRuPL_giktSkFK_g7w-mGi_OEQ9fVXF2UVzw@mail.gmail.com>
Subject: Re: [PATCH] slab: fix the DEADLOCK issue on l3 alien lock
From: Pekka Enberg <penberg@kernel.org>
To: paulmck@linux.vnet.ibm.com
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:29 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Sep 06, 2012 at 11:05:11AM +0800, Michael Wang wrote:
>> On 09/05/2012 09:55 PM, Christoph Lameter wrote:
>> > On Wed, 5 Sep 2012, Michael Wang wrote:
>> >
>> >> Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
>> >> fake report generated.
>> >
>> > Ahh... That is a key insight into why this occurs.
>> >
>> >> This should not happen since we already have init_lock_keys() which will
>> >> reassign the lock class for both l3 list and l3 alien.
>> >
>> > Right. I was wondering why we still get intermitted reports on this.
>> >
>> >> This patch will invoke init_lock_keys() after we done enable_cpucache()
>> >> instead of before to avoid the fake DEADLOCK report.
>> >
>> > Acked-by: Christoph Lameter <cl@linux.com>
>>
>> Thanks for your review.
>>
>> And add Paul to the cc list(my skills on mailing is really poor...).
>
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I'd also like to tag this for the stable tree to avoid bogus lockdep
reports. How far back in release history should we queue this?
