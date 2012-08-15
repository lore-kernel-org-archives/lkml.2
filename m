Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HOPwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:52:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2HOPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:52:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 28/31] arm64: Generic timers support
Date: Wed, 15 Aug 2012 15:52:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-29-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151552.40484.arnd@arndb.de>
X-Provags-ID: V02:K0:TxHzGosXIlLmnH8VyaOYiHRHOs6ENM6XLgOlxt+c3DF
 osHNWmi1Q4hAy2AYcI642qhZ0F3gXtUCtZGPc2lXPUJtIL+Wwt
 xSBxH6vfQTHLnfebIbLmBPl/1CbllvrWoOODHKLykcKeWvgp68
 hpDNlRlU6wNn8eoLnHQLOY0zJi6BBcUzoCDaSkxh9sAwt77pEa
 wF0lTTXgIdd1g3IKwfSV8cW+8Rrz67aVGLTE1l7fkshb/SAMbB
 BBP0ER06KdHu+RYp2j2UWcqHml84uunIfuhzkd25BCrjB004Ak
 WYFwgJ56MYX3guZUjOHyAyioNcXVIzDrRJ8WITdXnD1ggNZSjw
 Oyk7HrUuAj6g1SNSYM9Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> +static void arch_timer_reg_write(int reg, u32 val)
> +{
> +       switch (reg) {
> +       case ARCH_TIMER_REG_CTRL:
> +               asm volatile("msr cntp_ctl_el0,  %0" : : "r" (val));
> +               break;
> +       case ARCH_TIMER_REG_TVAL:
> +               asm volatile("msr cntp_tval_el0, %0" : : "r" (val));
> +               break;
> +       default:
> +               BUG();
> +       }
> +
> +       isb();
> +}
> +
> +static u32 arch_timer_reg_read(int reg)
> +{
> +       u32 val;
> +
> +       switch (reg) {
> +       case ARCH_TIMER_REG_CTRL:
> +               asm volatile("mrs %0,  cntp_ctl_el0" : "=r" (val));
> +               break;
> +       case ARCH_TIMER_REG_FREQ:
> +               asm volatile("mrs %0,   cntfrq_el0" : "=r" (val));
> +               break;
> +       case ARCH_TIMER_REG_TVAL:
> +               asm volatile("mrs %0, cntp_tval_el0" : "=r" (val));
> +               break;
> +       default:
> +               BUG();
> +       }
> +
> +       return val;
> +}

Are the inline assemblies the only things in this driver that are
specific to AArch64?
Are you planning to use the same file for 32 bit ARM as well, e.g.
when running a 32 bit guest kernel on a 64 bit host?

	Arnd
