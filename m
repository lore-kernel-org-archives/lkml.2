Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2APUQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:16:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42095 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2APUQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:16:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120116173309.GA21112@redhat.com>
References: <cover.1326673414.git.luto@amacapital.net> <7bed6cc87d8f388269a73b1a9a4c9ebd6ac333da.1326673414.git.luto@amacapital.net>
 <20120116173309.GA21112@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jan 2012 12:15:43 -0800
Message-ID: <CALCETrXX6E8iSrek_dMjWPxBso142NLe3FObwsW_EJjNdZ4-uw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
To: Oleg Nesterov <oleg@redhat.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 9:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/15, Andy Lutomirski wrote:
>>
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1117,6 +1117,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       if (retval < 0)
>>               goto bad_fork_free;
>>
>> +     p->no_new_privs = current->no_new_privs;
>
> Again, this is unneeded, ->no_new_privs was copied by dup_task_struct().

Yeah, sorry.  Will fix in v3.

--Andy
