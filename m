Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1DTHeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:34:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49027 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1DTHeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rLuKa6jW5MXLtuHjGB+Z3CZlBXKBpu+a2aqFR4KPOsEq+Rfd2ctpZX5EVhUcCexQKS
         1IUNpri9my6NZDnjG4EI9V6Eo4CUHDs/Cn2Q5iATfmd1H7Stu+vZUbTAKAVw1tmAdPUJ
         F80GxFpCCT272WgbZRIUS0hJsqNZhXdTQhhAA=
MIME-Version: 1.0
In-Reply-To: <20110420161615.462D.A69D9226@jp.fujitsu.com>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com>
	<BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>
	<20110420161615.462D.A69D9226@jp.fujitsu.com>
Date: Wed, 20 Apr 2011 10:34:23 +0300
X-Google-Sender-Auth: mc-uokeCFBxGJtCTURz7SkvWshY
Message-ID: <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, Apr 20, 2011 at 4:23 AM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > I'm worry about this patch. A lot of mm code assume !NUMA systems
>> > only have node 0. Not only SLUB.
>>
>> So is that a valid assumption or not? Christoph seems to think it is
>> and James seems to think it's not. Which way should we aim to fix it?
>> Would be nice if other people chimed in as we already know what James
>> and Christoph think.

On Wed, Apr 20, 2011 at 10:15 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> I'm sorry. I don't know it really. The fact was gone into historical myst. ;-)
>
> Now, CONFIG_NUMA has mainly five meanings.
>
> 1) system may has !0 node id.
> 2) compile mm/mempolicy.c (ie enable mempolicy APIs)
> 3) Allocator (kmalloc, vmalloc, alloc_page, et al) awake NUMA topology.
> 4) enable zone-reclaim feature
> 5) scheduler makes per-node load balancing scheduler domain
>
> Anyway, we have to fix this issue.  I'm digging which fixing way has least risk.
>
>
> btw, x86 don't have an issue. Probably it's a reason why this issue was neglected
> long time.
>
> arch/x86/Kconfig
> -------------------------------------
> config ARCH_DISCONTIGMEM_ENABLE
>        def_bool y
>        depends on NUMA && X86_32

That part makes me think the best option is to make parisc do
CONFIG_NUMA as well regardless of the historical intent was.

                        Pekka
