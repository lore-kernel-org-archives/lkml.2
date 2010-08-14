Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab0HNAwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:52:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756512Ab0HNAwW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:52:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100814001158.GA2849@suse.de>
References: <20100813214704.GA18960@kroah.com> <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
 <20100813230712.GA1703@suse.de> <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com> <20100814001158.GA2849@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Aug 2010 17:51:56 -0700
Message-ID: <AANLkTin0Gb0q_jgJDROqBGsM4fa=LiAax-J0Q4FRyRGG@mail.gmail.com>
Subject: Re: [0/3] 2.6.27.52 stable review
To: Greg KH <gregkh@suse.de>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 5:11 PM, Greg KH <gregkh@suse.de> wrote:
>
> That's a warning that current->mm is null.  I don't know enough about
> the mm subsystem to say if this is normal or not, and I don't at first
> glance, see how this patch could have caused this to happen.

We call that whole "expand_stack()" through handle_mm_fault(), and
that's _not_ called just for the process itself. So "current->mm" is
sometimes simply the wrong thing to use - like when you access the VM
of another process (during fork for the argument setup of the new VM,
or during ptrace etc).

Which is why I think commit 05fa199d45c should fix it. It makes the
stack expansion thing use the right mm. Which it just _happened_ to do
before, because it was always called just from the faulting code where
current->mm happened to be the right mm.

But I really don't know if there might be other issues lurking too.

                        Linus
