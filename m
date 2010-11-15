Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0KOJvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:51:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0KOJvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:51:10 -0500
Message-ID: <4CE1038D.9020403@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 17:55:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
References: <4CDCE2B0.7000601@cn.fujitsu.com> <4CDCE3C2.9030107@cn.fujitsu.com> <4CDFBE00.2000802@redhat.com> <4CE0C45C.809@cn.fujitsu.com> <4CE0FDBC.20505@redhat.com>
In-Reply-To: <4CE0FDBC.20505@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 17:51:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 17:51:32,
	Serialize complete at 2010-11-15 17:51:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 05:30 PM, Avi Kivity wrote:

>> Yeah, this 'retry' is unnecessary if the process is killed, but this
>> case is infrequent, the most case is the process keeps running and try
>> to access the fault address later.
> 
> The problem is that if we retry in this case, we install an incorrect spte?
> 

......

>> can avoid if the page mapping have been fixed.
> 
> The guest may have changed page directories or other levels.
> 

......

>> >  Or another thread may have mmap()ed something else over the
>> >  same address.
>>
>> The mmap virtual address is also visible for other threads since the
>> threads
>> have the same page table, so i think this case is the same as above?
> 
> Again, don't we install the wrong spte in this case?
> 

I think it doesn't corrupts spte since we will walk guest page table again
and map it to shadow pages when we retry #PF.
