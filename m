Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab2AMUTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:19:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51236 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab2AMUTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyaVyUE7vif_VVcywG6YpBqVsY=qT0DsZiecNQnx_ddSQ@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
 <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
 <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
 <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com>
 <CALCETrU=7Xs_Kf1d45=68zbXCkjLVTs9+fUFg58ZZTQZfHZ_1A@mail.gmail.com> <CA+55aFyaVyUE7vif_VVcywG6YpBqVsY=qT0DsZiecNQnx_ddSQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jan 2012 12:19:12 -0800
Message-ID: <CALCETrU487rqcVi_dx5BP4vCo4T+n6BoWtX6_SBVqUsK0eSgdw@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 13, 2012 at 12:05 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> I'm confused.  The patch does "no security context changes on execve".
>
> So that's what I wanted and thought you did, but your comment:
>
>  "With my patch, selinux can already block the execve if it wants"
>
> is what I reacted to. The "selinux *can*" and the "if it wants" part
> was what made my hackles rise.
>
> If it is not about what selinux can and what selinux wants, I'm happy.
> The security manager shouldn't have any choices in the matter. No
> 'can', no 'want'.
>
> Your choice of words made me think your patch had left that door open.

Fair enough.

It's unavoidable that selinux can block the exec, though -- it could
prevent you from reading the file, in which case good luck execing it
:)

I'll respin this so that it doesn't oops if bisected with AppArmor
running.  Any maintainers want to pick it up?

--Andy
