Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2ALUBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:01:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44596 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2ALUBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:01:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7G7TpLL9QUmzEfjEqtg3G06O+rjO-Hy6snS5j2rmbXHXQ@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
 <1326385635.7642.89.camel@gandalf.stny.rr.com> <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
 <CAObL_7HE6_NE79tKASQcAxyvCS_7L=vMqfjvZDbCe99pa2t8Wg@mail.gmail.com>
 <CA+55aFwLoOT-5oRn0k9oErAhTW4hT0_-bMXsn-mf00zcxmHheQ@mail.gmail.com>
 <CAObL_7GXw8XpVHJrBABUQt9u9pXFDnzUP3nxagS1+g7tPE1kew@mail.gmail.com>
 <CABqD9hYynwP6ViTZi_7XH7OWbZ7SHskU9W6roX2yD5rwqBO96Q@mail.gmail.com> <CAObL_7G7TpLL9QUmzEfjEqtg3G06O+rjO-Hy6snS5j2rmbXHXQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 12:00:58 -0800
X-Google-Sender-Auth: aqRUSrPtBrZGIH1-1WXS4i33D9w
Message-ID: <CA+55aFxszOU=RzZ8Hgof+AAi+F2xW71-KX9DZqOJTT=vQ9gSnQ@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Andrew Lutomirski <luto@mit.edu>
Cc: Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:46 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> I think securebits and cred didn't exist the first time I did this,
> and sticking it in struct cred might unnecessarily prevent sharing
> cred (assuming that even happens).  So I'd say task_struct.

I think it almost has to be task state, since we very much want to
make sure it's trivial to see that nothing ever clears that bit, and
that it always gets copied right over a fork/exec/whatever.

Putting it in some cred or capability bit or somethin would make that
kind of transparency pretty much totally impossible.

                 Linus
