Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2HOSnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:43:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57007 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2HOSng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120815194426.52fd7936@pyramind.ukuu.org.uk>
References: <20120726134748.GA20605@localhost>
	<CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
	<20120810015222.GA19286@localhost>
	<CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
	<20120815030110.GA24836@localhost>
	<CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
	<20120815130159.GA3221@redhat.com>
	<1345041021.31459.88.camel@twins>
	<20120815175651.GA17814@redhat.com>
	<CAGXu5jJ+HOdSxS7Ec=TW06h6KEpEmi-rF+Jk8L5LiQsp9gyAtg@mail.gmail.com>
	<20120815194426.52fd7936@pyramind.ukuu.org.uk>
Date: Wed, 15 Aug 2012 11:43:34 -0700
X-Google-Sender-Auth: SwEzhQe03rU7GbzxOyLtaAAu91A
Message-ID: <CAGXu5jLFHjybsJOcTCZOtgaifmYYioJK0Tm0dvSA7d31HMRwHA@mail.gmail.com>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:44 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> It sounds like get_task_comm shouldn't have locking at all then? It
>> should just do a length-limited copy and make sure there is a trailing
>> 0-byte?
>
> It has locking so that it has a consistent state and more importantly it
> has an accessor function
>
> Directly accessing it is asking for bugs in future. If you hold the
> needed lock then just add an
>
> __get_task_comm()
>
> method that asserts the lock is held. That way the rest of the behaviour
> remains properly encapsulated for when someone changes it.

But what's been discussed is that no lock is needed if the caller
doesn't care about the accuracy of the contents, which is the
situation I'm in. Looking at other readers of ->comm, they just either
use it directly or copy it directly. Only when accuracy matters does
the kernel use get_task_comm.

-Kees

-- 
Kees Cook
Chrome OS Security
