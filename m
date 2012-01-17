Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2AQQcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:32:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64871 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2AQQcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:32:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120117162309.GA16336@redhat.com>
References: <cover.1326673414.git.luto@amacapital.net> <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
 <20120117162309.GA16336@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Jan 2012 08:31:58 -0800
Message-ID: <CALCETrXZfg7qYjNu_B9CTuKa1tEjPSyzqPDXm8m_oGiNAPrO_w@mail.gmail.com>
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
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

On Tue, Jan 17, 2012 at 8:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/15, Andy Lutomirski wrote:
>>
>> Chroot can easily be used to subvert setuid programs.  If no_new_privs,
>> then setuid programs don't gain any privilege, so allow chroot.
>>
>> ...
>>
>> +     if (!(current->no_new_privs && !is_chrooted) &&
>> +         !capable(CAP_SYS_CHROOT))
>
> I must have missed something. How no_new_privs can help if fs->users != 1 ?

Whoops.  That needs fixing.

--Andy
