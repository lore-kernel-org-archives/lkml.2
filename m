Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2JLCaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:30:25 -0400
Received: from ozlabs.org ([203.10.76.45]:51902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab2JLCaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:30:22 -0400
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
In-Reply-To: <5074A0AB.8040207@zytor.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 12 Oct 2012 08:46:49 +1030
Message-ID: <87d30o7iy6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 10/10/2012 06:03 AM, Michael Kerrisk (man-pages) wrote:
>> Good point. A "whole hog" openat()-style interface is worth thinking about too.
>
> *Although* you could argue that you can always simply open the module
> file first, and that finit_module() is really what we should have had in
> the first place.  Then you don't need the flags since those would come
> from openat().

There's no fundamental reason that modules have to be in a file.  I'm
thinking of compressed modules, or an initrd which simply includes all
the modules it wants to load in one linear file.

Also, --force options manipulate the module before loading (as did the
now-obsolete module rename option).

Cheers,
Rusty.
