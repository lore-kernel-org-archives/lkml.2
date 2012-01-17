Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2AQQw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:52:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2AQQw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:52:56 -0500
Date: Tue, 17 Jan 2012 17:45:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, indan@nul.nu
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
	BPF
Message-ID: <20120117164523.GA17070@redhat.com>
References: <1326302710-9427-2-git-send-email-wad@chromium.org> <20120112162231.GA23960@redhat.com> <CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com> <20120112172315.GA26295@redhat.com> <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com> <20120113173153.GA24273@redhat.com> <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com> <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com> <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Will Drewry wrote:
>
> On Mon, Jan 16, 2012 at 12:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes, thanks, I forgot about compat tasks again. But this is easy, just
> > we need regs_64_to_32().
>
> Yup - we could make the assumption that is_compat_task is always
> 32-bit and the pt_regs is always 64-bit, then copy_and_truncate with
> regs_64_to_32.  Seems kinda wonky though :/

much simpler/faster than what regset does to create the artificial
user_regs_struct32.

> > Doesn't matter. I think Indan has a better suggestion.
>
> I disagree, but perhaps I'm not fully understanding!

I have much more chances to be wrong ;) I leave it to you and Indan.

Oleg.

