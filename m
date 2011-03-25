Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354Ab1CYBSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:18:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165Ab1CYBSp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:18:45 -0400
MIME-Version: 1.0
In-Reply-To: <1300980654.2398.3.camel@localhost.localdomain>
References: <417044.386125298-sendEmail@jojo-hp-compaq-8100-elite-cmt-pc> <1300980654.2398.3.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 18:17:50 -0700
Message-ID: <AANLkTi=yQ=n8xNC2GdXic_O6yQYD0r0D8QZwb2CqSk4r@mail.gmail.com>
Subject: Re: [Patch 1/1] fsnotify,fanotify: adding flag for execution
To: Eric Paris <eparis@redhat.com>
Cc: "jozef.kralik@eset.sk" <jozef.kralik@eset.sk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:30 AM, Eric Paris <eparis@redhat.com> wrote:
>
> I keep waffling back and forth on this patch (for months now) mostly
> because of the fact that I'm scared it will give people a false sense
> that they will get notification of all files that might be executed.  I
> don't understand the use case at all so I don't know if it good idea to
> expose such notifications....

We have indeed historically had those kinds of bugs. For example,
having 'noexec' disable execve() on files, but *not* disabling using
them as LD_PRELOAD=xyz things where they aren't the target of an
execve(), but the code in them is run anyway (thanks to just an
executable mmap(), or even a "read()" into a data segment that is
executable)

So I don't know what makes "executed" different from "read". Because
at some point we really cannot tell the difference.

The one special thing about execve() is that it can execute something
even when it's not readable. But people who have depended on that as a
security feature have always been disappointed (ie just execve it and
then use ptrace to read the contents of the file _anyway_). So once
again it's not at all clear that "execute" should ever be considered
to be anything but "read".

                  Linus
