Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab1IKOqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:46:08 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:41676 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab1IKOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <CALGyLaiXhtceaJxni9ttjMfzx6K326_CVccJiifAhXfNszdgsg@mail.gmail.com>
References: <CALGyLaiXhtceaJxni9ttjMfzx6K326_CVccJiifAhXfNszdgsg@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 11 Sep 2011 10:45:45 -0400
Message-ID: <CAOPLpQdU8k2e2TN4mj+T9cPJnVTP_Js9q7YH6iqq1Z0_5NM4kQ@mail.gmail.com>
Subject: Re: pselect semantics - no EINTR with pending signals
To: Maciek Borzecki <maciek.borzecki@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 09:25, Maciek Borzecki <maciek.borzecki@gmail.com> wrote:
> Now, I'm not sure about the semantics of pselect. I'm not saying that
> the current version is right or wrong, but raising a question if this
> is really expected (and it did happen to be quite unexpected for me).

The standard says

       If  sigmask  is not a null pointer, then the pselect() function
shall replace the signal mask of the
       process by the set of signals pointed to by sigmask before
examining  the  descriptors,  and  shall
       restore the signal mask of the process before returning.

The way I read this the kernel does have to give the signal a chance
to be delivered even if there are file descriptor ready for I/O.
