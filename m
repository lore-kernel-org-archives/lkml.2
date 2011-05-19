Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab1ESPEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:04:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932781Ab1ESPEv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 May 2011 08:04:28 -0700
Message-ID: <BANLkTinXfXa8+xUSPPy46uY0Rk1e6xdPLg@mail.gmail.com>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#2
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 11:17 AM, Tejun Heo <tj@kernel.org> wrote:
>
> This is the second try at implementing PTRACE_SEIZE/INTERRUPT and
> group stop notification.  Notable changes from the first take[1] are,
>
> * Prep patches moved to a separate patchset[2].

So having followed the discussion so far, quite frankly I'm not
convinced this series is 2.6.40 material.

I think that conceptually the split-up of PTRACE_ATTACH into
SEIZE/INTERRUPT might be fine, but I don't think the interface is
necessarily cooked, and perhaps more importantly I'm not at all sure
that the (few) current users of ptrace() would even switch over.

So I think Oleg's branch with cleanups is probably ready, and maybe a
few of the preparatory patches from this branch can be merged, but I
would _strongly_ suggest that the plan for 2.6.40 should be to not
actually mess with interfaces to the kernel, but just cleaning up the
actual internal implementation. I would like to keep 2.6.40 small and
simple.

Comments?

                       Linus
