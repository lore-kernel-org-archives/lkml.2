Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0DHCnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:43:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0DHCnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:43:40 -0400
Message-ID: <4BBD42BE.20307@kernel.org>
Date: Thu, 08 Apr 2010 11:43:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: graff yang <graff.yang@gmail.com>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>	 <4BA449E2.3080707@kernel.org>	 <7d86d44a1003211933h6628ae04vc9d1c393e1733ce5@mail.gmail.com>	 <4BB47367.8030305@kernel.org> <y2l4e5ebad51004060228t814129beqd0d90059e247e48d@mail.gmail.com>
In-Reply-To: <y2l4e5ebad51004060228t814129beqd0d90059e247e48d@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030705090603010602030506"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 02:43:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030705090603010602030506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello, Sonic.

> I tested your patch on NOMMU bf561 with SMP enabled. It is compiled
> and boots without problem. Because there are few percpu data defined
> in bf561 SMP kernel, the functions in mm/percpu-km.c may not be
> executed with a simple test. But, since these functions are simple
> malloc/free, I don't see any problem.

Great, thanks for testing.  Just in case, can you please test with the
attached module?  In test-pcpu.c, the cmds table directs the module
what to allocate and free.  { size > 0, tag } entry makes it allocate
an area with the specified size and tag and { 0, tag } entry makes it
free all areas with the matching tag.  The existing table makes pretty
large amount of allocations and might not work very well on nommu
configuration.  There are also several DEFINE_PER_CPU() instances to
test module static percpu area alloc/free.  Please insmod/rmmod in
loop and make sure it doesn't leak any memory or crashes the machine.

Thanks.

-- 
tejun

--------------030705090603010602030506
Content-Type: application/x-gzip;
 name="test-pcpu.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="test-pcpu.tar.gz"

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
BAQEBAQEBAQEBAQEBJbgP6JHIvcAUAAA
--------------030705090603010602030506--
