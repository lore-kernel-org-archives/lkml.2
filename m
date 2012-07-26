Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2GZJf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:35:28 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46801 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GZJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:35:23 -0400
Message-ID: <50110F51.3050903@linux.vnet.ibm.com>
Date: Thu, 26 Jul 2012 17:35:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: remove dummy pages
References: <5010C008.4030304@linux.vnet.ibm.com> <5010C083.30102@linux.vnet.ibm.com>	<5011062F.3080505@redhat.com> <20120726182033.e127e9e6.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120726182033.e127e9e6.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072609-5490-0000-0000-000001DA77CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 05:20 PM, Takuya Yoshikawa wrote:
> On Thu, 26 Jul 2012 11:56:15 +0300
> Avi Kivity <avi@redhat.com> wrote:
> 
>> Since my comments are better done as a separate patch, I applied all
>> three patches.  Thanks!
> 
> Is this patch really safe for all architectures?
> 
> IS_ERR_VALUE() casts -MAX_ERRNO to unsigned long and then does comparison.
> Isn't it possible to conflict with valid pfns?
> 

See IS_ERR_VALUE():

#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)

The minimal value of the error code is:
0xffff f001 on 32-bit and 0x ffff ffff ffff f001 on 64-bit,
it is fair larger that a valid pfn (for the pfn, the most top of 12 bits
are always 0).

Note, PAE is a special case, but only 64G physical memory is valid,
0xffff f001 is also suitable for that.

