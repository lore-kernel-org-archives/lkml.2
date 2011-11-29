Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1K2WMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:12:00 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39588 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab1K2WL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:11:58 -0500
Message-ID: <4ED5584D.9010606@us.ibm.com>
Date: Tue, 29 Nov 2011 16:10:21 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: qemu-devel@nongnu.org, ryanh@linux.vnet.ibm.com, mtosatti@redhat.com,
        avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Guest stop notification
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11112922-1976-0000-0000-000007FD034E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 03:36 PM, Eric B Munson wrote:
> Often when a guest is stopped from the qemu console, it will report spurious
> soft lockup warnings on resume.  There are kernel patches being discussed that
> will give the host the ability to tell the guest that it is being stopped and
> should ignore the soft lockup warning that generates.
>
> Signed-off-by: Eric B Munson<emunson@mgebm.net>

Reviewed-by: Anthony Liguori <aliguori@us.ibm.com>

Regards,

Anthony Liguori

> Cc: ryanh@linux.vnet.ibm.com
> Cc: aliguori@us.ibm.com
> Cc: mtosatti@redhat.com
> Cc: avi@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   target-i386/kvm.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> index 5bfc21f..defd364 100644
> --- a/target-i386/kvm.c
> +++ b/target-i386/kvm.c
> @@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *env)
>       return 0;
>   }
>
> +static void kvm_put_guest_paused(CPUState *penv)
> +{
> +    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
> +}
> +
>   static void cpu_update_state(void *opaque, int running, RunState state)
>   {
>       CPUState *env = opaque;
>
>       if (running) {
>           env->tsc_valid = false;
> +	kvm_put_guest_paused(env);
>       }
>   }
>

