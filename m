Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2DEV4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:56:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40607 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2DEVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120405214447.GC7761@count0.beaverton.ibm.com>
References: <20120331091049.19373.28994.stgit@zurg> <20120331092929.19920.54540.stgit@zurg>
 <20120331201324.GA17565@redhat.com> <20120402230423.GB32299@count0.beaverton.ibm.com>
 <4F7A863C.5020407@openvz.org> <20120403181631.GD32299@count0.beaverton.ibm.com>
 <20120403193204.GE3370@moon> <20120405202904.GB7761@count0.beaverton.ibm.com>
 <4F7E08EB.5070600@openvz.org> <20120405214447.GC7761@count0.beaverton.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2012 14:55:29 -0700
X-Google-Sender-Auth: A4-eUBaaB7CDC2SGNB059rPGCGU
Message-ID: <CA+55aFzH=nTAxxqMpQKJAVFOEngwkArmufqe_Mq5hyLR_9Vfqw@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 2:44 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
>
> I don't think the definition of an ABI is whether there's documentation
> for it. It's whether the interface is used or not. At least that's the
> impression I've gotten from reading Linus' rants over the years.

Yes.

That said, I *do* have some very dim memory of us having had real
issues with the /proc/<pid>/exe thing and having regressions due to
holding refcounts to executables that were a.out binaries and not
demand-loaded. And people wanting to unmount filesystems despite the
binaries being live.

That said, I suspect that whatever issues we used to have with that
are pretty long gone. I don't think people use non-mmap'ed binaries
any more. So I think we can try it and see. And revert if somebody
actually notices and has problems.

                    Linus
