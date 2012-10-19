Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2JSC2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:28:25 -0400
Received: from ozlabs.org ([203.10.76.45]:58466 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab2JSC2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:28:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>, mtk.manpages@gmail.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <508011AD.5080307@zytor.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <507F848F.50707@zytor.com> <CAKgNAki+KV=Nh8D3La50uXpWv7PA5T-oPYJwK-PkOv5vMg0AqA@mail.gmail.com> <508011AD.5080307@zytor.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 19 Oct 2012 12:53:14 +1030
Message-ID: <87a9vjp5d9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
> Given that, I have to say I now seriously question the value of 
> finit_module().  The kernel can trivially discover if the pointed-to 
> memory area is a MAP_SHARED mmap() of a file descriptor and if so which 
> file descriptor... why can't we handle this behind the scenes?

It is a bit more indirect, but also in practice it's a bit trickier than
that.  We need to ensure the memory doesn't change underneath us and
stays attached to that fd.  I can easily see that code slipping and
ending in an exploit.

But that may be my irrational fear of the mm :)

Cheers,
Rusty.
