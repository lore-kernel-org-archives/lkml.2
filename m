Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1ILIrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:47:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43921 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab1ILIre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAOPLpQdU8k2e2TN4mj+T9cPJnVTP_Js9q7YH6iqq1Z0_5NM4kQ@mail.gmail.com>
References: <CALGyLaiXhtceaJxni9ttjMfzx6K326_CVccJiifAhXfNszdgsg@mail.gmail.com>
 <CAOPLpQdU8k2e2TN4mj+T9cPJnVTP_Js9q7YH6iqq1Z0_5NM4kQ@mail.gmail.com>
From: Maciek Borzecki <maciek.borzecki@gmail.com>
Date: Mon, 12 Sep 2011 10:47:13 +0200
Message-ID: <CALGyLagJ1pL=4PBPTp-uzwAnTB_hrZuqW93xUd=45dOKpb3-GA@mail.gmail.com>
Subject: Re: pselect semantics - no EINTR with pending signals
To: Ulrich Drepper <drepper@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 4:45 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Fri, Sep 9, 2011 at 09:25, Maciek Borzecki <maciek.borzecki@gmail.com> wrote:
>> Now, I'm not sure about the semantics of pselect. I'm not saying that
>> the current version is right or wrong, but raising a question if this
>> is really expected (and it did happen to be quite unexpected for me).
>
> The standard says
>
>       If  sigmask  is not a null pointer, then the pselect() function
> shall replace the signal mask of the
>       process by the set of signals pointed to by sigmask before
> examining  the  descriptors,  and  shall
>       restore the signal mask of the process before returning.
>
> The way I read this the kernel does have to give the signal a chance
> to be delivered even if there are file descriptor ready for I/O.
I do agree, otherwise the signal delivery gating functionality of
pselect is not really useful.

I'd submit a patch, provided that current behavior is considered
incorrect. Hopefully userspace would not be affected to the degree
that things would get broken.

--
Maciek Borzecki
