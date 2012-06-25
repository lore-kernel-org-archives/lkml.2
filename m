Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab2FYW25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:28:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab2FYW2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:28:55 -0400
Date: Mon, 25 Jun 2012 15:28:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] fs: make dumpable=2 require fully qualified path
Message-Id: <20120625152853.1ec6a824.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jL8XpkWhFkWtdQA7egR+pOmu5TVjK7NTzeVEr=sqcmePw@mail.gmail.com>
References: <20120625180327.GA31931@www.outflux.net>
	<20120625151409.5e13702b.akpm@linux-foundation.org>
	<CAGXu5jL8XpkWhFkWtdQA7egR+pOmu5TVjK7NTzeVEr=sqcmePw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 15:20:19 -0700
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Jun 25, 2012 at 3:14 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 25 Jun 2012 11:03:27 -0700
> > Kees Cook <keescook@chromium.org> wrote:
> >
> >> Instead of introducing a suid_dumpable=3 mode and breaking all users
> >> of mode 2, this only disables the unsafe portion of mode 2 (writing to
> >> disk via relative path).
> >
> > It would be nicer to generate the warning at configuration time rather than
> > at core-dumping time. __I have a feeling that's Hard To Do, but why?
> 
> I actually feel that this is much more discoverable because anyone
> trying to figure out why a crash isn't dumping core isn't going to be
> looking back in time through their dmesg to find the warning from
> setting the sysctl. Additionally, I think it's the same kind of thing
> that the other existing "Skipping core dump" printk messages are
> reporting.

People who don't discover we changed their kernel until after they lost
an important core dump will be sad.  Do both?


