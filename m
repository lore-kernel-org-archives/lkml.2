Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1FHDo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:44:56 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50727 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1FHDoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:44:54 -0400
Date: Wed, 8 Jun 2011 12:47:40 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
Message-Id: <20110608124740.14c807f7.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4DEEED3C.3070302@cn.fujitsu.com>
References: <4DEE205E.8000601@cn.fujitsu.com>
	<20110608121128.2caecdb3.yoshikawa.takuya@oss.ntt.co.jp>
	<4DEEEBB6.5090805@cn.fujitsu.com>
	<4DEEED3C.3070302@cn.fujitsu.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 11:32:12 +0800
Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> On 06/08/2011 11:25 AM, Xiao Guangrong wrote:
> > On 06/08/2011 11:11 AM, Takuya Yoshikawa wrote:
> >> On Tue, 07 Jun 2011 20:58:06 +0800
> >> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> >>
> >>> The performance test result:
> >>>
> >>> Netperf (TCP_RR):
> >>> ===========================
> >>> ept is enabled:
> >>>
> >>>       Before         After
> >>> 1st   709.58         734.60
> >>> 2nd   715.40         723.75
> >>> 3rd   713.45         724.22
> >>>
> >>> ept=0 bypass_guest_pf=0:
> >>>
> >>>       Before         After
> >>> 1st   706.10         709.63
> >>> 2nd   709.38         715.80
> >>> 3rd   695.90         710.70
> >>>
> >>
> >> In what condition, does TCP_RR perform so bad?
> >>
> >> On 1Gbps network, directly connecting two Intel servers,
> >> I got 20 times better result before.
> >>
> >> Even when I used a KVM guest as the netperf client,
> >> I got more than 10 times better result.
> >>
> > 
> > Um, which case did you test? ept = 1 or ept=0 bypass_guest_pf=0 or both?
> > 

ept = 1 only.

> >> Could you tell me a bit more details of your test?
> >>
> > 
> > Sure, KVM guest is the client, and it uses e1000 NIC, and uses NAT
> > network connect to the netperf server, the bandwidth of our network
> > is 100M.
> > 

I see the reason, thank you!

I used virtio-net and you used e1000.
You are using e1000 to see the MMIO performance change, right?

  Takuya

> 
> And this is my test script:
> 
> #!/bin/sh
> 
> echo 3 > /proc/sys/vm/drop_caches
> ./netperf -H $HOST_NAME -p $PORT -t TCP_RR -l 60
> 
