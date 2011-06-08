Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1FHDXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:23:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59962 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1FHDXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:23:39 -0400
Message-ID: <4DEEEBB6.5090805@cn.fujitsu.com>
Date: Wed, 08 Jun 2011 11:25:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com> <20110608121128.2caecdb3.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20110608121128.2caecdb3.yoshikawa.takuya@oss.ntt.co.jp>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 11:23:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-08 11:23:27,
	Serialize complete at 2011-06-08 11:23:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 11:11 AM, Takuya Yoshikawa wrote:
> On Tue, 07 Jun 2011 20:58:06 +0800
> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> The performance test result:
>>
>> Netperf (TCP_RR):
>> ===========================
>> ept is enabled:
>>
>>       Before         After
>> 1st   709.58         734.60
>> 2nd   715.40         723.75
>> 3rd   713.45         724.22
>>
>> ept=0 bypass_guest_pf=0:
>>
>>       Before         After
>> 1st   706.10         709.63
>> 2nd   709.38         715.80
>> 3rd   695.90         710.70
>>
> 
> In what condition, does TCP_RR perform so bad?
> 
> On 1Gbps network, directly connecting two Intel servers,
> I got 20 times better result before.
> 
> Even when I used a KVM guest as the netperf client,
> I got more than 10 times better result.
> 

Um, which case did you test? ept = 1 or ept=0 bypass_guest_pf=0 or both?

> Could you tell me a bit more details of your test?
> 

Sure, KVM guest is the client, and it uses e1000 NIC, and uses NAT
network connect to the netperf server, the bandwidth of our network
is 100M.

