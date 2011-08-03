Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1HCGAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:00:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab1HCGAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:00:44 -0400
Message-ID: <4E38E477.2000208@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 14:02:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/12] KVM: x86: tag the instructions which are used
 to write page table
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DA73.7010908@cn.fujitsu.com> <4E37EB8E.6080207@redhat.com>
In-Reply-To: <4E37EB8E.6080207@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 13:59:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 13:59:32,
	Serialize complete at 2011-08-03 13:59:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 08:20 PM, Avi Kivity wrote:
> On 08/02/2011 02:07 PM, Xiao Guangrong wrote:
>> The idea is from Avi:
>> | tag instructions that are typically used to modify the page tables, and drop
>> | shadow if any other instruction is used
>> | The list would include, I'd guess, and, or, bts, btc, mov, xchg, cmpxchg, and
>> | cmpxchg8b
>>
>> This patch is used to tag the instructions and in the later path, shadow page
>> is dropped if it is written by other instructions
> 
> We already have a mechanism for this, the decode tables.  Why not add a new flag, PageTable, and set it on all relevant instructions?
> 

OK, will do it in the next version.

> Note we don't need to actually emulate, just decode, since page_fault can tell us whether a write failed due to page tables or mmio.
> 

This is a interesting feature. If it happens, i will just drop the shadow pages
and retry these instructions directly.
