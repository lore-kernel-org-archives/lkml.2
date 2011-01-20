Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1ATAT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:19:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1ATAT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:19:56 -0500
Date: Wed, 19 Jan 2011 16:19:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Fabio M. Di Nitto" <fabbione@fabbione.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daid Miller <davem@davemloft.net>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>
Subject: Re: [PATCH] console: allow to retain boot console via boot option
 keep_bootcon
Message-Id: <20110119161918.1f827080.akpm@linux-foundation.org>
In-Reply-To: <1294821624-24544-1-git-send-email-fabbione@fabbione.net>
References: <1294821624-24544-1-git-send-email-fabbione@fabbione.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 09:40:24 +0100
"Fabio M. Di Nitto" <fabbione@fabbione.net> wrote:

> From: Fabio M. Di Nitto <fdinitto@redhat.com>
> 
> On some architectures, the boot process involves de-registering the boot
> console (early boot), initialize drivers and then re-register the console.
> 
> This mechanism introduces a window in which no printk can happen on the console
> and messages are buffered and then printed once the new console is available.
> 
> If a kernel crashes during this window, all it's left on the boot console
> is "console [foo] enabled, bootconsole disabled" making debug of the crash
> rather 'interesting'.
> 
> By adding "keep_bootcon" option, do not unregister the boot console, that
> will allow to printk everything that is happening up to the crash.
> 
> The option is clearly meant only for debugging purposes as it introduces lots
> of duplicated info printed on console, but will make bug report from users
> easier as it doesn't require a kernel build just to figure out where we crash.
> 

I don't get it, as usual.

The architecture does

a) deregister boot console
b) initialize drivers
c) register console

and the patch basically disables step a).

But if we can do that without screwing things up, why not simply change
the architecture to not deregister the boot console until after
initializing the drivers?


