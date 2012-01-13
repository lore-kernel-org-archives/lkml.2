Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab2AMTpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:45:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2AMTpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
 <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com> <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 11:45:12 -0800
X-Google-Sender-Auth: gSA5tctjAMNPg8W5VhqRLkrMO7Y
Message-ID: <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Andy Lutomirski <luto@amacapital.net>
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

On Fri, Jan 13, 2012 at 11:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Is the current exec_no_trans check enough for you?  With my patch,
> selinux can already block the execve if it wants.

If this feature has "selinux can do xyz if it wants", it is broken.

The *whole* point is to get the f*^%ing crazy "security managers can
do xyz" things away from it.

The flag - when set - should give a 100% guarantee that security
context doesn't change, and an operation that would change it would
error out.

Not a "selinux can block it if it wants". None of that "wants" crap.
None of the "you can configure security rules to do xyz" crap.

One simple rule: no security changes from the context that set the flag.

Any other rule will inevitably cause random gray areas where some
random security manager does something stupid. We have enough of those
already. No more.

                     Linus
