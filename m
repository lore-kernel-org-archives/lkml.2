Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2ECOEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:04:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57765 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2ECOEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:04:46 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: mtk.manpages@gmail.com
Cc: Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
In-Reply-To: <CAKgNAkiRH8p=Dp1tqkb3D9oRVCOSnj2bofgFN5x2svntN7vtPg@mail.gmail.com>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org> <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com> <877gwxacti.fsf@skywalker.in.ibm.com> <CAKgNAkiRH8p=Dp1tqkb3D9oRVCOSnj2bofgFN5x2svntN7vtPg@mail.gmail.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 03 May 2012 19:34:35 +0530
Message-ID: <87bom5xswc.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12050303-7014-0000-0000-0000010694BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Aneesh,
>
>>
>> I don't know much about markers, but as per fsnotify_backend.h
>>
>> /*
>>  * a mark is simply an object attached to an in core inode which allows an
>>  * fsnotify listener to indicate they are either no longer interested in events
>>  * of a type matching mask or only interested in those events.
>>  *
>>  * these are flushed when an inode is evicted from core and may be flushed
>>  * when the inode is modified (as seen by fsnotify_access).  Some fsnotify users
>>  * (such as dnotify) will flush these when the open fd is closed and not at
>>  * inode eviction or modification.
>>  */
>> struct fsnotify_mark {
>
> Unfortunately, I'm still none the wiser about what this means for
> O_PATH file descriptors...
>

I looked at dnotify_flush, they remove markers on an inode.
But then it also checks for filp to match. So I am not sure
whether skipping dnotify_flush for O_PATH descriptor have any impact. We
can't use O_PATH descriptor for dnotify fcntl any way. So in
dnotify_flush we will not match the filp.

Viro,

Any reason why we skip dnotify_flush  ?


-aneesh

