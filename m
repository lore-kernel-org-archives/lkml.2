Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1FPEqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:46:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab1FPEp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110615213549.9b399976.randy.dunlap@oracle.com>
References: <201106160359.p5G3x3j4020081@hera.kernel.org> <20110615213549.9b399976.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 21:45:00 -0700
Message-ID: <BANLkTimPwZsWNi=t57xz+h11gLn4CkOfug@mail.gmail.com>
Subject: Re: fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 9:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> fwiw, I just reported that this causes a build error in UML on x86_64
> in mmotm-2011-06-15:

Gaah. That sounds really familiar. Have we done this same mistake once
before already, or is it just deja-vu for some other reason.

On x86-64 UML, we have

  #define VM_STACK_DEFAULT_FLAGS vm_stack_flags

so VM_STACK_FLAGS ends up not being a constant, even though it really
looks like one.

UML is _really_ confused in this area, btw. It seems to re-define that
thing if TIF_IA32 is defined. That's some crazy stuff. Doesn't the
compiler warn about it?

I guess I should just revert that commit, though. Even if it does seem
to be the case that UML is just being crazy. Andrew?

                  Linus
