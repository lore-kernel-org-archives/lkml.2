Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1BWBhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:37:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1BWBhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:37:34 -0500
Message-ID: <4D646517.8030702@cn.fujitsu.com>
Date: Wed, 23 Feb 2011 09:38:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/7] KVM: MMU: cache guest page number to guest frame
 number
References: <4D636EF8.60800@cn.fujitsu.com> <4D6370E8.6080008@cn.fujitsu.com> <4D63C8F9.1020708@redhat.com>
In-Reply-To: <4D63C8F9.1020708@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 09:36:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 09:36:30,
	Serialize complete at 2011-02-23 09:36:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:32 PM, Avi Kivity wrote:
> On 02/22/2011 10:16 AM, Xiao Guangrong wrote:
>> Cache guest page number to guest frame number to avoid walk guest page table
>> frequently, the 'vtlb' idea is from Xen.
>>
>> Note:
>> we can't use vtlb in ept guests since the guest tlb invalid operation is not
>> intercept(reload CR3, invlpg), also can't used in L2 nnpt guest for the same
>> reason, but we can used it to cache L1's npt page table.
>>
> 
> I'm not so hot about introducing a new mechanism strictly for older hosts... EPT exists in three generations of Intel processors now (Sandy Bridge, Westmere, and Nehalem), and NPT is significantly older.
> 

Um...so, do we should stop the new features for softmmu, only bug fix is welcome? :-)
