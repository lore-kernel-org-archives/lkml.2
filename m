Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423442Ab2KNVJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:09:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422629Ab2KNVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:09:10 -0500
Date: Wed, 14 Nov 2012 13:09:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <aedilger@gmail.com>,
        John Sobecki <john.sobecki@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        jakub@redhat.com, drepper@redhat.com,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RESEND PATCH V3] binfmt_elf.c: use get_random_int() to fix
 entropy depleting
Message-Id: <20121114130909.2dcc5b75.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jLC9aj3KewbFb2tHoisjvqj4KkMwpA6KiZ7y8k15WWOwA@mail.gmail.com>
References: <5099F133.5030305@oracle.com>
	<5099FBAA.6000200@oracle.com>
	<CAGXu5jLpE5kTGGqLqDRwRaEOt+nhpKc52jQFs+rsa+0GVKA-vw@mail.gmail.com>
	<509A078D.8060705@oracle.com>
	<CAGXu5jLC9aj3KewbFb2tHoisjvqj4KkMwpA6KiZ7y8k15WWOwA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012 23:13:54 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Tue, Nov 6, 2012 at 11:02 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> > On 11/07/2012 02:21 PM, Kees Cook wrote:
> >> I still want to hear at least from Ted about this changes -- we would
> >> be potentially increasing the predictability of these bytes...
> >
> > We would not increasing that if this routine would be used for AT_RANDOM
> > only(and if the array keeping aligned to 4 bytes).
> > Otherwise, it would be, so let's waiting for further feedbacks.
> 
> get_random_int() comes from a different pool than get_random_bytes(),
> IIUC. I'd like to hear some convincing reasoning as to why this change
> doesn't compromise predictability. :)

But the original "ELF: implement AT_RANDOM for glibc PRNG seeding"
compromised predictability.  That's the whole point of this patch.

What was so important about that patch that justified gobbling down so
much of the system's entropy accumulation?

