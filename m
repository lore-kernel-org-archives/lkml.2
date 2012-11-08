Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2KHHKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:10:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33060 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab2KHHKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:10:35 -0500
MIME-Version: 1.0
In-Reply-To: <1352281674-2186-9-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
	<1352281674-2186-9-git-send-email-vgupta@synopsys.com>
Date: Thu, 8 Nov 2012 08:10:34 +0100
Message-ID: <CACM3HyHYiuhGb6tcY0kS43y+kquWF11Du+g45pzoJukSpE0ANw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2012 10:47, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
> new file mode 100644
> index 0000000..c178357
> --- /dev/null
> +++ b/arch/arc/include/asm/ptrace.h
> @@ -0,0 +1,120 @@
> +/* THE pt_regs: Defines how regs are saved during entry into kernel */
> +
> +struct pt_regs {

I'd recommend not exporting the pt_regs structure to userspace.  This
struct is used heavily within the kernel and it's nice to have the
leeway to be able to modify it as things evolve.  GDB doesn't need to
know about this struct anymore as it should be using regset's for any
recent architectures anyway, so it's the regset layout that should be
ABI stable instead of pt_regs.

You can check the openrisc architecture as an example of how to do this.

/Jonas
