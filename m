Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3ACKnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:43:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39171 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3ACKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:43:34 -0500
Date: Thu, 3 Jan 2013 10:38:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: kpark3469@gmail.com
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
Message-ID: <20130103103815.GL2631@n2100.arm.linux.org.uk>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com> <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 07:12:29PM +0900, kpark3469@gmail.com wrote:
> -#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
> +#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_ARM_UNWIND)
>  /*
>   * return_address uses walk_stackframe to do it's work.  If both
>   * CONFIG_FRAME_POINTER=y and CONFIG_ARM_UNWIND=y walk_stackframe uses unwind
> - * information.  For this to work in the function tracer many functions would
> - * have to be marked with __notrace.  So for now just depend on
> - * !CONFIG_ARM_UNWIND.

So what have you done about the issue referred in this comment?  Or do you
believe that fixing warnings (even if they are explicit #warning statements)
is far more important than code being functionally correct?
