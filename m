Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1A0Cew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 21:34:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56183 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1A0Cev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 21:34:51 -0500
Message-ID: <4D40D9F7.6000006@cn.fujitsu.com>
Date: Thu, 27 Jan 2011 10:35:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] KVM: fix rcu usage warning in kvm_arch_vcpu_ioctl_set_sregs()
References: <4D2D5AA6.9080804@cn.fujitsu.com> <4D3673A7.4090402@cn.fujitsu.com> <20110119181347.GA13142@amt.cnet> <4D37A603.4040602@cn.fujitsu.com> <20110120152736.GA3922@amt.cnet>
In-Reply-To: <20110120152736.GA3922@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-27 10:34:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-27 10:34:11,
	Serialize complete at 2011-01-27 10:34:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 11:27 PM, Marcelo Tosatti wrote:

>> Sure :-), there is the simply test result of kernbench:
>>
>> Before patch:
>>
>> real    5m6.493s                                                                
>> user    3m57.847s                                                               
>> sys     9m7.115s 
>>
>> real    5m1.750s                                                                
>> user    4m0.109s                                                                
>> sys     9m10.192s       
>>
>>
>> After patch:
>> real    5m0.140s                                                                
>> user    3m57.956s                                                               
>> sys     8m58.339s  
>>
>> real    4m56.314s                                                               
>> user    4m0.303s                                                                
>> sys     8m55.774s  
> 
> Nice. One disadvantageous side effect for the kvm_vcpu_kick path 
> is that it can race with make_all_cpus_request, which is possibly
> doing unrelated, slower work (IPI'ing other vcpus, waiting for
> response).
> 
> Looks ok, but lets wait for more careful reviews before applying.
> 

Hi Avi, Marcelo,

I shall on vacation from 1.25 to 2.9, if you have comments on it i'll
replay after coming back. :-)

