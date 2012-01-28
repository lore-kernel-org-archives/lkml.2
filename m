Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab2A1UNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 15:13:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52360 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2A1UNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 15:13:15 -0500
MIME-Version: 1.0
In-Reply-To: <1327749669.15441.9.camel@cr0>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<1327706681-11959-2-git-send-email-wad@chromium.org>
	<1327749669.15441.9.camel@cr0>
Date: Sat, 28 Jan 2012 12:13:13 -0800
Message-ID: <CABqD9hZh-Rkjgvn8fu2PUf-KRHmBEiai3cJhcoPZ8-FHbW7BzQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, indan@nul.nu, mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 3:21 AM, Cong Wang <amwang@redhat.com> wrote:
> On Fri, 2012-01-27 at 17:24 -0600, Will Drewry wrote:
>> +config SECCOMP_FILTER
>> +       bool "Enable seccomp-based system call filtering"
>> +       select SECCOMP
>
> Is 'depends on SECCOMP' better?

Either way is fine for me.  I chose select so that SECCOMP_FILTER
wouldn't be hidden if SECCOMP was off when they hit the security menu.

>
>> +       help
>> +         This option provide support for limiting the accessibility
>> of
>
> s/provide/provides/
>
>> +         systems calls at a task-level using a dynamically defined
>> policy.
>
>
> s/systems/system/
>
>> +
>> +         System call filtering policy is expressed by the user using
>> +         a Berkeley Packet Filter program.  The program is attached
>> using
>
> s/the user using//
>
>> +         prctl(2).  For every system call the task makes, its number,
>> +         arguments, and other metadata will be evaluated by the
>> attached
>> +         filter program.  The result determines if the system call
>> may
>> +         may proceed or if the task should be terminated.
>
> One more "may"... and "be proceeded"
>
>> +
>> +         This behavior is meant to aid security-conscious software in
>> +         its ability to minimize the risk of running potentially
>> +         risky code.
>> +
>> +         See Documentation/prctl/seccomp_filter.txt for more detail.
>> +
>
>
> Thanks.

Thanks!  Cleaned up, as recommended, and slightly reworded.  I'll
include the updates in the next salvo.
