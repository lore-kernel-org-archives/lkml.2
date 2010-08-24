Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0HXQyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:54:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766Ab0HXQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:54:12 -0400
MIME-Version: 1.0
In-Reply-To: <4c73f3ed34663af90@agluck-desktop.sc.intel.com>
References: <4c73f3ed34663af90@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Aug 2010 09:53:12 -0700
Message-ID: <AANLkTinQ_0zGJnPHw7AMJ+q+oo4nmA9Z4irw8dqRH9S8@mail.gmail.com>
Subject: Re: [PATCH] guard page for stacks that grow upwards
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 9:31 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> Updated to match the new code - still not tested on pa-risc.

But the ia64 grows-up case is tested?

> The #ifdefs are ugly - suggestions welcome on how to make
> the code prettier.

One thing I've considered is to get rid of the CONFIG_STACK_GROWSUP
crap entirely in code, and instead just make the VM_GROWSUP #define be
0 for architectures that don't want it. The compiler should then just
automatically remove all the code that says

   if (vma->vm_flags & VM_GROWSUP) {
     ...

and the code would look more straightforward. Hmm?

                    Linus
