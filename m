Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0KEH7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:59:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab0KEH7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:59:05 -0400
Message-ID: <4CD3BA50.1000002@cn.fujitsu.com>
Date: Fri, 05 Nov 2010 16:03:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
References: <4CD28B5F.1040205@cn.fujitsu.com> <4CD28BCA.1060907@cn.fujitsu.com> <20101104103548.GE6018@redhat.com> <4CD39886.4050909@cn.fujitsu.com> <20101105074533.GC14910@redhat.com>
In-Reply-To: <20101105074533.GC14910@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-05 15:59:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-05 15:59:36,
	Serialize complete at 2010-11-05 15:59:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 03:45 PM, Gleb Natapov wrote:

>>
>> It looks like something broken: apfs can generated in L2 guest (nested ntp guest)
>> and be retried in L1 guest.
>>
> Why is this a problem? apf will be generate on direct map even when L2
> guest is running so it should be OK to prefault it into direct map on
> completion.
> 

The nested_cr3 is different between L2 and L1, fix L2's page fault in L1's page table
is useless.
