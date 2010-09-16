Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0IPOAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab0IPOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:00:39 -0400
Message-ID: <4C922302.20900@redhat.com>
Date: Thu, 16 Sep 2010 16:00:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: Use base_role.nxe for mmu.nx
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com> <1284479173-4515-3-git-send-email-joerg.roedel@amd.com> <20100914220836.GA3553@amt.cnet> <20100915084833.GH17759@amd.com>
In-Reply-To: <20100915084833.GH17759@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/15/2010 10:48 AM, Roedel, Joerg wrote:
> On Tue, Sep 14, 2010 at 06:08:37PM -0400, Marcelo Tosatti wrote:
> >
> >  For tdp better set base_role.nxe to zero, otherwise duplicate tdp
> >  pagetables can be created if the guest switches between nx/non-nx.
> >
>
> This does not work because bit 63 is marked as reserved if base_role.nxe
> is 0. If the walk_addr_generic function then runs with tdp enabled it
> would report a set nx bit as a rsvd fault.
> We also can't use is_nx() in those path because it does not distinguish
> between l1 and l2 nx. Are there guests that switch the efer.nx bit
> regularly enough so that it matters? If so I would suggest to drop this
> patch and keep mmu.nx.
>
>

I'll do that then.  I'm still unhappy about the duplication.

-- 
error compiling committee.c: too many arguments to function

