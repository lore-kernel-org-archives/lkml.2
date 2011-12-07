Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1LGOjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:39:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab1LGOjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:39:11 -0500
Message-ID: <4EDF7A72.5020703@redhat.com>
Date: Wed, 07 Dec 2011 16:38:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5 V5] Add check for suspended vm in softlockup detector
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <1323116344-17911-6-git-send-email-emunson@mgebm.net>
In-Reply-To: <1323116344-17911-6-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 10:19 PM, Eric B Munson wrote:
> A suspended VM can cause spurious soft lockup warnings.  To avoid these, the
> watchdog now checks if the kernel knows it was stopped by the host and skips
> the warning if so.  When the watchdog is reset successfully, clear the guest
> paused flag.
>
>  int watchdog_enabled = 1;
> @@ -280,6 +281,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  			__this_cpu_write(softlockup_touch_sync, false);
>  			sched_clock_tick();
>  		}
> +
> +		/* Clear the guest paused flag on watchdog reset */
> +		kvm_check_and_clear_guest_paused(smp_processor_id());
>  		__touch_watchdog();
>  		return HRTIMER_RESTART;
>  	}

Won't build if !CONFIG_KVMCLOCK


-- 
error compiling committee.c: too many arguments to function

