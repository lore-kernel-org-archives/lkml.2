Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab2FVU5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:57:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2FVU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:57:06 -0400
Date: Fri, 22 Jun 2012 13:57:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>, Per Forlin <per.forlin@stericsson.com>,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.lkml@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] reboot: disable nonboot CPUs
Message-Id: <20120622135704.658eb79c.akpm@linux-foundation.org>
In-Reply-To: <20120614214834.GB14301@moon>
References: <1339709115-531-1-git-send-email-per.forlin@stericsson.com>
	<CAGXu5jKqaddf3T+LMS-6VMgH98JbMG-NsjB8uajNw19R7OAfig@mail.gmail.com>
	<20120614214834.GB14301@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 01:48:34 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Thu, Jun 14, 2012 at 02:41:48PM -0700, Kees Cook wrote:
> > On Thu, Jun 14, 2012 at 2:25 PM, Per Forlin <per.forlin@stericsson.com> wrote:
> > > Disable the nonboot CPUs to safely migrate tasks and interrupts
> > > to the boot CPU. This will prevent the nonboot CPUs to
> > > interfer or block the boot CPU from being able to reboot
> > > the system successfully.
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> > This seems reasonable to me, though I haven't looked too deeply at the
> > reboot path.
> 
> Looks reasonable to me as well, but better to add some more CC,

That worked well :(

> since syscore_shutdown seems to call for generic irqs to shutdown
> when cpu get turned off already, not sure if this have any side
> effect and/or I've missed something (Thomas CC'ed).

Let's use the scientific method: stick it in the tree and see what
happens.  If it breaks, we fix or revert it.
