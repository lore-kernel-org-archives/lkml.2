Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab1LNWLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:11:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38627 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1LNWLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:11:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAK3+h2zaZ3J4F4_rx6LGM0f_iY7ao8rU9nCt3EpZXDRGrqm3hQ@mail.gmail.com>
References: <CAK3+h2zaZ3J4F4_rx6LGM0f_iY7ao8rU9nCt3EpZXDRGrqm3hQ@mail.gmail.com>
Date: Wed, 14 Dec 2011 23:11:45 +0100
Message-ID: <CACRpkdbcLYoVEN6HJjw=Wq=5e77LJjnSQmwMD4K+UM4h+jDhBg@mail.gmail.com>
Subject: Re: Seeking Linux watchdog design advice to trouble shoot mystory
 silent reboot issue
From: Linus Walleij <linus.walleij@linaro.org>
To: Vincent Li <vincent.mc.li@gmail.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 8:55 PM, Vincent Li <vincent.mc.li@gmail.com> wrote:

> we have  a complex system with a large number of processes running
> simutanously. If any of the processes gets into a faulty state and
> hangs or consumes more than its fair share of the system resources,
> the other processes may not get a chance to run, and the whole system
> can hang, interrupting the system functionality and user traffic.

Have you tried using RLIMITs?

Last time I used something like this from each process:

#include <sys/time.h>
#include <sys/resource.h>

struct rlimit rl;
int ret;

// No process run more than 5 seconds
rl.rlim_cur = rl.rlim_max = 5;
ret = setrlimit(RLIMIT_CPU, &rl);
// No realtime process run more than 1 second
rl.rlim_cur = rl.rlim_max = 1000000;
ret = setrlimit(RLIMIT_RTTIME, &rl);

The latter is good if you have real-time processes.

There are also RLIMITs for memory consumption.

Consult:
http://kernel.org/doc/man-pages/online/pages/man2/getrlimit.2.html

> CPU and memory control group features are not considered at this stage
> because it is too invasive to change in our custom kernel.

Do you mean that you are using an antique kernel with many custom
patches and you don't want to upgrade because it's a lot of work?
Mainlining your code and keeping each patch topic on a special
git branch (and using git) are recommended practices.

If you mean you have been stripping it down for footprint then
it's another thing which I can fully understand...

Yours,
Linus Walleij
