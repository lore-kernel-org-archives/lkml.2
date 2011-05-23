Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1EWUqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:46:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1EWUqv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:46:51 -0400
MIME-Version: 1.0
In-Reply-To: <1306182652-25493-1-git-send-email-richard@nod.at>
References: <1306182652-25493-1-git-send-email-richard@nod.at>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 13:46:30 -0700
Message-ID: <BANLkTikh0R7EBaG1q4GQz1Te5jmWtA42GQ@mail.gmail.com>
Subject: Re: [PATCH] um: use RWSEM_GENERIC_SPINLOCK on x86
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "# .39.x" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 1:30 PM, Richard Weinberger <richard@nod.at> wrote:
>
>  config RWSEM_XCHGADD_ALGORITHM
> -       def_bool X86_XADD
> +       def_bool X86_XADD && 64BIT
>
>  config RWSEM_GENERIC_SPINLOCK
> -       def_bool !X86_XADD
> +       def_bool !X86_XADD || !64BIT

May I suggest just changing that second one to

  config RWSEM_GENERIC_SPINLOCK
      def_bool !RWSEM_XCHGADD_ALGORITHM

because I had to look twice just to make sure that they are inverses
of each other.

So why not make that inverse relationship more obvious?

                         Linus
