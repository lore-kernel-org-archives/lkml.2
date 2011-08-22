Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1HVOgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1HVOgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:36:41 -0400
Message-ID: <4E526975.4080106@redhat.com>
Date: Mon, 22 Aug 2011 17:36:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 02/11] KVM: x86: tag the instructions which are used to
 write page table
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A1117.1030608@cn.fujitsu.com> <20110822143235.GA4797@amt.cnet>
In-Reply-To: <20110822143235.GA4797@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 05:32 PM, Marcelo Tosatti wrote:
> On Tue, Aug 16, 2011 at 02:41:27PM +0800, Xiao Guangrong wrote:
> >  The idea is from Avi:
> >  | tag instructions that are typically used to modify the page tables, and
> >  | drop shadow if any other instruction is used.
> >  | The list would include, I'd guess, and, or, bts, btc, mov, xchg, cmpxchg,
> >  | and cmpxchg8b.
> >
> >  This patch is used to tag the instructions and in the later path, shadow page
> >  is dropped if it is written by other instructions
>
> What is the advantage of doing this again? What is the point of
> dropping shadow if the instruction is emulated?
>

So it won't be emulated again; the assumption is that if you addl into a 
page, it isn't a pagetable.

-- 
error compiling committee.c: too many arguments to function

