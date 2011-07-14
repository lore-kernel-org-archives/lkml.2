Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1GNNko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:40:44 -0400
Received: from 8bytes.org ([88.198.83.132]:47084 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab1GNNkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:40:43 -0400
Date: Thu, 14 Jul 2011 15:40:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: SVM: Use seperate VMCB for L2 guests
Message-ID: <20110714134041.GE24072@8bytes.org>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-5-git-send-email-joerg.roedel@amd.com> <4E1ED53F.7030903@redhat.com> <20110714131228.GD24072@8bytes.org> <4E1EEE8F.2050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1EEE8F.2050409@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 04:26:39PM +0300, Avi Kivity wrote:
> On 07/14/2011 04:12 PM, Joerg Roedel wrote:
>> Makes sense. I'll probably remove the lazy allocation and initialize
>> both VMCBs at vcpu-creation time. The memory foodprint is the same as
>> before because the hsave area was also allocated at the beginning.
>
> Related, would we need a pool of n_vmcbs/vmcb02s?

Probably. This depends on how nested-svm will be used I think. It is not
very hard to add if really needed. Some kind of LRU is certainly needed
too then.

> I guess the condition for reusing an n_vmcb would be: same vmcb_gpa and  
> at least one clean bit set?

Same vmcb_gpa is sufficient I think. I nothing is marked clean then it
is the same situation as if the vmcb_gpa is different.

	Joerg

