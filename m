Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2JSSdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:33:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51234 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2JSSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <5081609C.9080702@gmail.com>
References: <506E43E0.70507@jp.fujitsu.com> <506E451E.1050403@jp.fujitsu.com>
 <CAHGf_=rVDm-JygjPoLHbmF28Dgd52HFc4-b5KCxhEieG60okuw@mail.gmail.com>
 <50812F13.20503@cn.fujitsu.com> <5081609C.9080702@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 14:33:17 -0400
X-Google-Sender-Auth: e6ez1pEwSHiveg3vm-cRe4nFdas
Message-ID: <CAHGf_=q=Agidyj_j6jhBdhNmJBy2u1dP+UMAoXbM=_=DyZJs_w@mail.gmail.com>
Subject: Re: [PATCH 1/10] memory-hotplug : check whether memory is offline or
 not when removing memory
To: Wen Congyang <wencongyang@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it again, and found that this check is necessary. Because we only
> lock memory hotplug when offlining pages. Here is the steps to offline and
> remove memory:
>
> 1. lock memory hotplug
> 2. offline a memory section
> 3. unlock memory hotplug
> 4. repeat 1-3 to offline all memory sections
> 5. lock memory hotplug
> 6. remove memory
> 7. unlock memory hotplug
>
> All memory sections must be offlined before removing memory. But we don't
> hold
> the lock in the whole operation. So we should check whether all memory
> sections
> are offlined before step6.

You should describe the race scenario in the patch description. OK?
