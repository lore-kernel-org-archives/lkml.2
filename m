Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1FMIGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:06:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1FMIGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:06:44 -0400
Message-ID: <4DF5C50D.2000007@redhat.com>
Date: Mon, 13 Jun 2011 11:06:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/15] KVM: optimize for MMIO handled
References: <4DEE205E.8000601@cn.fujitsu.com> <4DF0789B.2050401@redhat.com> <4DF19803.9040407@cn.fujitsu.com> <4DF47D0A.9060604@redhat.com> <4DF5961A.6050006@cn.fujitsu.com>
In-Reply-To: <4DF5961A.6050006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 07:46 AM, Xiao Guangrong wrote:
> >>
> >>  and it has little heavy sine we need to walk guest page table,
> >>  and build spte under mmu-lock.
> >
> >  For shadow, yes, this is a good optimization.  But with nested paging it slow things down.  We already have the gpa, so all we need to do is follow the mmio path.  There's no need to walk the spte hierarchy.
> >
>
> Yes, it is, i just want to detect BUG for KVM, it helps us to know if "ept misconfig" is the
> real MMIO or the BUG. I noticed some "ept misconfig" BUGs is reported before, so i think doing
> this is necessary, and i think it is not too bad, since walking spte hierarchy is lockless,
> it really fast.

Okay.  We can later see if it show up on profiles.


-- 
error compiling committee.c: too many arguments to function

