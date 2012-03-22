Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2CVXJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:09:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760105Ab2CVXJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:09:46 -0400
Date: Thu, 22 Mar 2012 16:09:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Christopher Li <sparse@chrisli.org>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
Message-Id: <20120322160944.ad06e559.akpm@linux-foundation.org>
In-Reply-To: <4F6BAD15.90802@openvz.org>
References: <20120321065140.13852.52315.stgit@zurg>
	<20120321100602.GA5522@barrios>
	<4F69D496.2040509@openvz.org>
	<20120322142647.42395398.akpm@linux-foundation.org>
	<20120322212810.GE6589@ZenIV.linux.org.uk>
	<20120322144122.59d12051.akpm@linux-foundation.org>
	<4F6BA221.8020602@openvz.org>
	<4F6BA69F.1040707@openvz.org>
	<CA+55aFz4hWfT5c93rUWvN4OsYHjOSAjmNtoT7Rkjz7kYsaC7xg@mail.gmail.com>
	<4F6BAD15.90802@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 02:52:05 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> >> Is this ok?
> >
> > Yes.
> >
> > The thing about __nocast is that it's so *very* very easy to lose it.
> > For example, do this:
> >
> >    typedef long __nocast long_t;
> >
> >    int main(long_t a)
> >    {
> >          return a;
> >    }
> >
> > and you get the (expected) warning.
> >
> > HOWEVER. Now do "return a+1" instead, and the warning goes away. Why?
> > Because the expression ends up having just the type "long", because
> > the "a" mixed happily with the "1" (that was cast from 'int' to 'long'
> > by the normal C type rules).
> >
> > That is arguably a bug, but this kind of thing really wasn't what
> > __nocast was designed for. The __nocast design ended up being too
> > weak, though, and we hardly use it in the kernel.
> >
> 
> Thanks. Looks like "__nocast" totally undocumented.
> It would be nice to add something about this into Documentation/sparse.txt

Yup, Chris has added this to his todo list (thanks!).
