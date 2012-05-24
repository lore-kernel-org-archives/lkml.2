Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2EXKdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2EXKda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:33:30 -0400
Message-ID: <4FBE0E75.8080503@redhat.com>
Date: Thu, 24 May 2012 13:33:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: introduce readonly memory region
References: <4FBDFE52.5090902@linux.vnet.ibm.com> <20120524095938.GX10209@redhat.com>
In-Reply-To: <20120524095938.GX10209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 12:59 PM, Gleb Natapov wrote:
> On Thu, May 24, 2012 at 05:24:34PM +0800, Xiao Guangrong wrote:
>> In current code, if we map a readonly memory space from host to guest
>> and the page is not currently mapped in the host, we will get a fault-pfn
>> and async is not allowed, then the vm will crash
>> 
>> Address Avi's idea, we introduce readonly memory region to map ROM/ROMD
>> to the guest
>> 
> As far as I can tell this implements only ROMD. i.e write access to read
> only slot will generate IO exit.

Which userspace can then ignore.  The question is whether writes to ROM
are frequent, and whether the performance in that case matters.


-- 
error compiling committee.c: too many arguments to function
