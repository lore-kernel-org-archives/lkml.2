Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2KEPzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:55:50 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:60545 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab2KEPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:55:49 -0500
Date: Mon, 5 Nov 2012 15:55:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: =?GB2312?B?taXOwA==?= <shanwei88@gmail.com>
cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <CAPYxyx+eJUWxDJrbOHVRtCchszmj8+BgSkNhpH3gGBJK87OikA@mail.gmail.com>
Message-ID: <0000013ad148e92a-ea123f83-e6f6-4131-8e15-8cf05cfd1e0a-000000@email.amazonses.com>
References: <5093EE6B.3070906@gmail.com> <20121102181026.GY3027@linux.vnet.ibm.com> <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com> <20121103091909.GI3027@linux.vnet.ibm.com> <509645A5.5070901@gmail.com>
 <0000013ad10bc571-9f707c9b-14e3-4382-a472-2a1aaa3fb384-000000@email.amazonses.com> <CAPYxyx+eJUWxDJrbOHVRtCchszmj8+BgSkNhpH3gGBJK87OikA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="288502408-1885430085-1352130896=:18751"
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--288502408-1885430085-1352130896=:18751
Content-Type: TEXT/PLAIN; charset=GB2312
Content-Transfer-Encoding: 8BIT

On Mon, 5 Nov 2012, ���� wrote:

> I guarantee that x86-64 don't use gs register here. run test again��
> Maybe there is some optimizations for __this_cpu_read call on x86-64�� not
> sure.

There is no optimization that I know of unless the compiler eliminated the
__this_cpu_read completely. gs: is necessary to perform the implied
relocation in this_cpu_read().


--288502408-1885430085-1352130896=:18751--
