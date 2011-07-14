Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1GNN0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab1GNN0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:26:45 -0400
Message-ID: <4E1EEE8F.2050409@redhat.com>
Date: Thu, 14 Jul 2011 16:26:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: SVM: Use seperate VMCB for L2 guests
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-5-git-send-email-joerg.roedel@amd.com> <4E1ED53F.7030903@redhat.com> <20110714131228.GD24072@8bytes.org>
In-Reply-To: <20110714131228.GD24072@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 04:12 PM, Joerg Roedel wrote:
> Makes sense. I'll probably remove the lazy allocation and initialize
> both VMCBs at vcpu-creation time. The memory foodprint is the same as
> before because the hsave area was also allocated at the beginning.

Related, would we need a pool of n_vmcbs/vmcb02s?

I guess the condition for reusing an n_vmcb would be: same vmcb_gpa and 
at least one clean bit set?

-- 
error compiling committee.c: too many arguments to function

