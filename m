Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2BGTKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab2BGTKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:10:19 -0500
Date: Tue, 7 Feb 2012 16:56:14 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 V11] Add functions to check if the host has stopped
 the vm
Message-ID: <20120207185614.GA19800@amt.cnet>
References: <1328024132-7687-1-git-send-email-emunson@mgebm.net>
 <1328024132-7687-3-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328024132-7687-3-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:35:30AM -0500, Eric B Munson wrote:
> When a host stops or suspends a VM it will set a flag to show this.  The
> watchdog will use these functions to determine if a softlockup is real, or the
> result of a suspended VM.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> asm-generic changes Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: mingo@redhat.com
> Cc: hpa@zytor.com
> Cc: ryanh@linux.vnet.ibm.com
> Cc: aliguori@us.ibm.com
> Cc: mtosatti@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes from V6:
>  Use __this_cpu_and when clearing the PVCLOCK_GUEST_STOPPED flag
> Changes from V5:
>  Collapse generic stubs into this patch
>  check_and_clear_guest_stopped() takes no args and uses __get_cpu_var()
>  Include individual definitions in ia64, s390, and powerpc
> 
>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/kvm_para.h     |    8 ++++++++
>  arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
>  5 files changed, 44 insertions(+), 0 deletions(-)

Where is the check_and_clear_guest_stopped() stub in
asm-generic/kvm_para.h? I think it is necessary for 
other architectures.


