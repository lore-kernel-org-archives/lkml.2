Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2LKUbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:31:39 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55465 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2LKUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:31:36 -0500
MIME-Version: 1.0
In-Reply-To: <CACLa4puuwbvSibSk2Q4t732jAyf=ncTMvYe_57opNTEz-2NLWw@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
 <1355234914.2356.85.camel@falcor> <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
 <1355249884.2356.108.camel@falcor> <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
 <1355252392.2356.131.camel@falcor> <CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
 <1355255320.2356.148.camel@falcor> <CA+55aFwaFqJQXR3Z8M3byube6hODmiT-dDEH3uFPSKpTDGXHaQ@mail.gmail.com>
 <CACLa4puuwbvSibSk2Q4t732jAyf=ncTMvYe_57opNTEz-2NLWw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Dec 2012 12:31:15 -0800
X-Google-Sender-Auth: LkSpQWQkdgHNURyAHOVAQx2rmWo
Message-ID: <CA+55aFwvgY9DLPu3=gtH-kOQ7M-zd94tL60Ts+WB6oNg3c2CKg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 12:15 PM, Eric Paris <eparis@parisplace.org> wrote:
>
> I know it isn't relevant to the final solution, but this is simply
> wrong.  IS_PRIVATE() means 'this inode is filesystem internal.'  It is
> not used by anything except rieser and the anon_inode.  If it is used
> by psuedo filesystems in general, like /proc, shmem mappings, and
> pipes that is a huge bug and is absolutely wrong.

Hmm.. The magic anonfs inode definitely sets it, as far as I can tell.

But it turns out that I was wrong anyway, and you are largely right:
pipes and sockets don't use the anonfs inode (they allocate their own
inodes directly using 'new_inode_pseudo()'), and neither does /proc.

So it's actually only signalfd and timerfd and some other special
things like kvm internal file descriptors that use it.

So never mind about S_PRIVATE, it has odd semantics.

                Linus
