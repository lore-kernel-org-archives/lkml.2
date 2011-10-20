Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1JTIiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:38:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33831 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab1JTIiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:38:18 -0400
Message-ID: <1319099893.3781.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
Date: Thu, 20 Oct 2011 10:38:13 +0200
In-Reply-To: <1319095929.23426.180.camel@debian>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>
	 <alpine.DEB.2.00.1110191033480.24001@router.home>
	 <1319078687.23426.146.camel@debian>
	 <1319087281.8416.45.camel@edumazet-laptop>
	 <1319095929.23426.180.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 octobre 2011 à 15:32 +0800, Alex,Shi a écrit :
> percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
> for further code clean up.
> 
> And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
> performance since __this_cpu_xxx has no redundant preempt_disable()
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  net/netfilter/xt_TEE.c |   12 ++++++------
>  net/socket.c           |    4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks !


