Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2FNVsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:48:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46280 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288Ab2FNVsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:48:39 -0400
Date: Fri, 15 Jun 2012 01:48:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-kernel@vger.kernel.org,
        serge.hallyn@canonical.com, Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.lkml@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] reboot: disable nonboot CPUs
Message-ID: <20120614214834.GB14301@moon>
References: <1339709115-531-1-git-send-email-per.forlin@stericsson.com>
 <CAGXu5jKqaddf3T+LMS-6VMgH98JbMG-NsjB8uajNw19R7OAfig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKqaddf3T+LMS-6VMgH98JbMG-NsjB8uajNw19R7OAfig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 02:41:48PM -0700, Kees Cook wrote:
> On Thu, Jun 14, 2012 at 2:25 PM, Per Forlin <per.forlin@stericsson.com> wrote:
> > Disable the nonboot CPUs to safely migrate tasks and interrupts
> > to the boot CPU. This will prevent the nonboot CPUs to
> > interfer or block the boot CPU from being able to reboot
> > the system successfully.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> This seems reasonable to me, though I haven't looked too deeply at the
> reboot path.

Looks reasonable to me as well, but better to add some more CC,
since syscore_shutdown seems to call for generic irqs to shutdown
when cpu get turned off already, not sure if this have any side
effect and/or I've missed something (Thomas CC'ed).

	Cyrill
