Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092Ab2KBMsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308Ab2KBMsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:48:39 -0400
Date: Fri, 2 Nov 2012 08:48:34 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Add modules_sign make target
Message-ID: <20121102124834.GQ6627@hansolo.jdub.homelinux.org>
References: <20121031135605.GJ6627@hansolo.jdub.homelinux.org>
 <87zk314w1t.fsf@rustcorp.com.au>
 <20121101112535.GL6627@hansolo.jdub.homelinux.org>
 <87ip9o4rpp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip9o4rpp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 01:49:14PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> 
> > On Thu, Nov 01, 2012 at 06:03:18PM +1030, Rusty Russell wrote:
> >> Josh Boyer <jwboyer@redhat.com> writes:
> >> 
> >> > If CONFIG_MODULE_SIG is set, and 'make modules_sign' is called then this
> >> > patch will cause the modules to get a signature appended.  The make target
> >> > is intended to be run after 'make modules_install', and will modify the
> >> > modules in-place in the installed location.  It can be used to produce
> >> > signed modules after they have been processed by distribution build
> >> > scripts.
> >> >
> >> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> >> 
> >> It's a bit of a niche case, but applied.
> >
> > Thanks.  Whether you consider RPM built kernels niche or not doesn't
> > matter to me.  Having this upstream is one less patch we have to carry
> > so I appreciate it a lot.
> 
> My comment was more that this relies on eu-strip, because we always
> sign modules on installation, so you need eu-strip to *unsign* them
> (strip won't do it, BTW).

Really?  Which version of binutils are you using?  The strip I have here
seems to have no qualms about stripping off the signatures:

[jwboyer@localhost crypto]$ hexdump -C blowfish-x86_64.ko | tail -5
000315d0  29 a3 6d 5e 38 01 23 b5  d8 53 cf db 01 04 01 1e  |).m^8.#..S......|
000315e0  14 00 00 00 00 00 02 02  7e 4d 6f 64 75 6c 65 20  |........~Module |
000315f0  73 69 67 6e 61 74 75 72  65 20 61 70 70 65 6e 64  |signature append|
00031600  65 64 7e 0a                                       |ed~.|
00031604
[jwboyer@localhost crypto]$ strip --strip-debug blowfish-x86_64.ko 
[jwboyer@localhost crypto]$ hexdump -C blowfish-x86_64.ko | tail -5
00004c20  01 00 00 00 2b 00 00 00  00 00 00 00 00 00 00 00  |....+...........|
00004c30  50 01 00 00 00 00 00 00  01 00 00 00 33 00 00 00  |P...........3...|
00004c40  00 00 00 00 00 00 00 00  50 02 00 00 00 00 00 00  |........P.......|
00004c50  01 00 00 00 2f 00 00 00  00 00 00 00 00 00 00 00  |..../...........|
00004c60
[jwboyer@localhost crypto]$ rpm -qf `which strip`
binutils-2.23.51.0.1-3.fc18.x86_64
[jwboyer@localhost crypto]$ 

So that makes me very curious.

> More general would be a modules_install_unsigned target to match this,
> but since noone would use it, let's not write it :)

Deal.

josh
