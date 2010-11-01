Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab0KAXVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 19:21:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43786 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0KAXVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 19:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WwW9lC1MiQJWhhJej8c/DF3SwbXqYVhYNadNcE/w01C5QClxn8t6LhzNmRzrQqT16Q
         KlN3bd6/5tznH7NvRgQDU3PHe0FnrOceoiUuokvYrD14fNta5+o8tzi6MeYH7vC1FY4C
         96t4hBKqNcGfNvgNvtLyBi74n38MhDmBZtKLk=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011012056250.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
	<20101101200122.GH840@cmpxchg.org>
	<alpine.LNX.2.00.1011012056250.12889@swampdragon.chaosbits.net>
Date: Tue, 2 Nov 2010 08:21:43 +0900
Message-ID: <AANLkTinAHXcG+ar2Wd9QjT58OOory_g87Tv4LnN53L-6@mail.gmail.com>
Subject: Re: [PATCH] cgroup: prefer [kv]zalloc over [kv]malloc+memset in
 memory controller code.
From: Minchan Kim <minchan.kim@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 4:59 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Mon, 1 Nov 2010, Johannes Weiner wrote:
>
>> On Mon, Nov 01, 2010 at 08:40:56PM +0100, Jesper Juhl wrote:
>> > Hi (please CC me on replies),
>> >
>> >
>> > Apologies to those who receive this multiple times. I screwed up the To:
>> > field in my original mail :-(
>> >
>> >
>> > In mem_cgroup_alloc() we currently do either kmalloc() or vmalloc() then
>> > followed by memset() to zero the memory. This can be more efficiently
>> > achieved by using kzalloc() and vzalloc().
>> >
>> >
>> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>>
>> Looks good to me, but there is also the memset after kmalloc in
>> alloc_mem_cgroup_per_zone_info().
>
> Dang, I missed that one. Thanks for pointing it out.
>
> Hmm, I'm wondering if we should perhaps add kzalloc_node()/vzalloc_node()
> just like kzalloc() and vzalloc()..

I am not against that.
As looking code, there are many places to use kzalloc_node but few vzalloc_node.
Although it is, Only adding kzalloc_node would make code rather ugly like this.

if (some size > limit)
  ptr =  kzalloc_node(...);
else  {
  prt = vmalloc_node(...)
  vmalloced = 1;
}

if (ptr && vmalloced)
   memset(prt, xxxx);

So if we will add kzalloc_node, we have to add vzalloc_node, too.

>
>> Can you switch that over as well in
>> this patch?  You can pass __GFP_ZERO to kmalloc_node() for zeroing.
>>
>
> Sure thing.
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
