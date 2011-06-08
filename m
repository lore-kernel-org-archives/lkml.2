Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1FHDHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:07:53 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49337 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1FHDHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:07:52 -0400
Date: Wed, 8 Jun 2011 12:11:28 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
Message-Id: <20110608121128.2caecdb3.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
References: <4DEE205E.8000601@cn.fujitsu.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jun 2011 20:58:06 +0800
Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> The performance test result:
> 
> Netperf (TCP_RR):
> ===========================
> ept is enabled:
> 
>       Before         After
> 1st   709.58         734.60
> 2nd   715.40         723.75
> 3rd   713.45         724.22
> 
> ept=0 bypass_guest_pf=0:
> 
>       Before         After
> 1st   706.10         709.63
> 2nd   709.38         715.80
> 3rd   695.90         710.70
> 

In what condition, does TCP_RR perform so bad?

On 1Gbps network, directly connecting two Intel servers,
I got 20 times better result before.

Even when I used a KVM guest as the netperf client,
I got more than 10 times better result.

Could you tell me a bit more details of your test?


> Kernbech (do not redirect output to /dev/null)
> ==========================
> ept is enabled:
> 
>       Before         After
> 1st   2m34.749s      2m33.482s
> 2nd   2m34.651s      2m33.161s
> 3rd   2m34.543s      2m34.271s
> 
> ept=0 bypass_guest_pf=0:
> 
>       Before         After
> 1st   4m43.467s      4m41.873s
> 2nd   4m45.225s      4m41.668s
> 3rd   4m47.029s      4m40.128s
> 
