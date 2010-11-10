Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0KJQMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:12:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55611 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab0KJQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:12:00 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: clear XD_DISABLED flag on Intel to regain NX
References: <20101109181157.GE5876@outflux.net>
	<20101109181501.GG5876@outflux.net>
Date: Wed, 10 Nov 2010 17:11:55 +0100
In-Reply-To: <20101109181501.GG5876@outflux.net> (Kees Cook's message of "Tue,
	9 Nov 2010 10:15:01 -0800")
Message-ID: <87hbfpp390.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:
> +
> +verify_cpu_clear_xd:
> +	movl	$MSR_IA32_MISC_ENABLE, %ecx
> +	rdmsr
> +	btrl	$2, %edx		# clear MSR_IA32_MISC_ENABLE_XD_DISABLE
> +	jnc	verify_cpu_check	# only write MSR if bit was
> changed

Strictly it's still a bit dangerous to read this MSR without knowing
about the CPU for sure. If you guess wrong you'll die here.

I would rather move this code later into the early init code (before the
second mapping is set up, which is still in time). There the exception
handlers are up and you could handle a #GP if it happens.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
