Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2BIIJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:09:18 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51702 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2BIIJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:09:17 -0500
MIME-Version: 1.0
X-Originating-IP: [109.64.24.177]
In-Reply-To: <op.v9cstne43l0zgt@mpn-glaptop>
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
	<1328449722-15959-6-git-send-email-gilad@benyossef.com>
	<op.v9cstne43l0zgt@mpn-glaptop>
Date: Thu, 9 Feb 2012 10:09:15 +0200
Message-ID: <CAOtvUMdo3yx1d5Ghs=GVBHCQGA8t9Vg=PK77h4V=hrLWDPUcUQ@mail.gmail.com>
Subject: Re: [PATCH v8 7/8] mm: only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/8 Michal Nazarewicz <mina86@mina86.com>:
> On Sun, 05 Feb 2012 14:48:41 +0100, Gilad Ben-Yossef <gilad@benyossef.com>
> wrote:
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d2186ec..3ff5aff 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1161,11 +1161,46 @@ void drain_local_pages(void *arg)
...
>> +
>> +       /* Allocate in the BSS so we wont require allocation in
>> +        * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
>> +        */
>
>
> If you are going to send next iteration, this comment should have
> “/*” on its own line just like comment below.

Right, thanks.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
