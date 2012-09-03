Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2ICJLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2ICJLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:11:34 -0400
Message-ID: <50447442.2050307@redhat.com>
Date: Mon, 03 Sep 2012 12:11:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: dave@gnu.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: invalidate vpid for invlpg instruction
References: <1346429448.2823.1.camel@offbook>  <20120831173707.GA3895@amt.cnet> <1346628440.3170.3.camel@offbook>
In-Reply-To: <1346628440.3170.3.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 02:27 AM, Davidlohr Bueso wrote:
> On Fri, 2012-08-31 at 14:37 -0300, Marcelo Tosatti wrote:
>> On Fri, Aug 31, 2012 at 06:10:48PM +0200, Davidlohr Bueso wrote:
>> > For processors that support VPIDs we should invalidate the page table entry
>> > specified by the lineal address. For this purpose add support for individual
>> > address invalidations.
>> 
>> Not necessary - a single context invalidation is performed through
>> KVM_REQ_TLB_FLUSH.
> 
> Since vpid_sync_context() supports both single and all-context vpid
> invalidations, wouldn't it make sense to also add individual address
> ones as well, supporting further granularity?

It might.  Do you have benchmarks supporting this?

-- 
error compiling committee.c: too many arguments to function
