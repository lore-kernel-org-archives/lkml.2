Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0ILI5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 04:57:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0ILI5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 04:57:04 -0400
Message-ID: <4C8C95DB.2030809@redhat.com>
Date: Sun, 12 Sep 2010 10:56:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/29] Nested Paging Virtualization for KVM v4
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/10/2010 06:30 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> as promised here is -v4 of my patch-set for virtualizing nested paging in KVM.
> I addresses all of your review comments in this version and fixed a misbehavior
> in the nested page-walker code where it would have reported the wrong
> error-code on an emulated nested page fault.
>
> Here is the complete list of changes:
>
> 	* Fixed the bug in the gpa_to_gfn function
> 	* Made sure that the right fault values are kept in the two-dimensional
> 	  page-table walker
> 	* Fixed the return code of x86_decode_insn so that a page-fault within
> 	  that function can be handled
> 	* Set vcpu->arch.mmu.direct_map to true for nonpaging mode too
> 	* Changed code so that the right access-mode is used on nested
> 	  page-table walks
> 	* Made the NX mode a capability of the MMU context to distinguish
> 	  between l1-nx and l2-nx (1 additional patch)
> 	* Fixed the bug that KVM always reports the SVM flag as supported to
> 	  userspace, it should only be reported on AMD hardware when nesting is
> 	  enabled
>
> As the patch-set before this one was tested with the same set of combinations
> too. I found no regressions to current avi/master. This patch-set applies on
> current avi/master plus the three fixes I sent last week.
>
> As with the last version of the patch-set I also pushed this one to a tree on
> korg. Find it in
>
> 	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git npt-virt-v4
>
> Please review these patches and/or apply them :-) As usual I appreciate your
> feedback.

All applied, thanks.  I'll go play with my new toy now.

-- 
error compiling committee.c: too many arguments to function

