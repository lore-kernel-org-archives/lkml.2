Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2FRWdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:33:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49372 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2FRWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:33:06 -0400
Message-ID: <1340058777.1572.35.camel@foo>
Subject: Re: linux-next: Tree for Jun 18 (kmsg problems)
From: Kay Sievers <kay@vrfy.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jun 2012 00:32:57 +0200
In-Reply-To: <CAPXgP10sBkwLnhDmu6UG9yVaiXG+8UYGkBEOVzUp3H+468J03w@mail.gmail.com>
References: <20120618165336.48345227c6b64c314326ae57@canb.auug.org.au>
	 <4FDF61A7.3050601@xenotime.net>
	 <20120619080109.b28055c1b32fb81027a9562b@canb.auug.org.au>
	 <20120618221535.GA13037@kroah.com>
	 <CAPXgP10sBkwLnhDmu6UG9yVaiXG+8UYGkBEOVzUp3H+468J03w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.2 (3.5.2-2.fc18)
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 00:17 +0200, Kay Sievers wrote:
> On Tue, Jun 19, 2012 at 12:15 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jun 19, 2012 at 08:01:09AM +1000, Stephen Rothwell wrote:
> >> [Adding Greg and Kay]
> >>
> >> On Mon, 18 Jun 2012 10:13:11 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
> >> >
> >> > arch/x86/kernel/reboot.o: In function `kmsg_dump_get_line':
> >> > reboot.c:(.text+0xf0): multiple definition of `kmsg_dump_get_line'
> >> > arch/x86/kernel/setup.o:setup.c:(.text+0x0): first defined here
> >> > arch/x86/kernel/reboot.o: In function `kmsg_dump_get_buffer':
> >> > reboot.c:(.text+0x100): multiple definition of `kmsg_dump_get_buffer'
> >> > arch/x86/kernel/setup.o:setup.c:(.text+0x10): first defined here
> >> > arch/x86/kernel/reboot.o: In function `kmsg_dump_rewind':
> >> > reboot.c:(.text+0x110): multiple definition of `kmsg_dump_rewind'
> >> > arch/x86/kernel/setup.o:setup.c:(.text+0x20): first defined here
> >>
> >> Caused by commit e2ae715d66bf ("kmsg - kmsg_dump() use iterator to
> >> receive log buffer content") from the driver-core.current tree.
> >
> > I'm building my tree right now, and I can't seem to hit this.
> >
> >> This was reported a few days ago.  Why is it not fixed yet?
> >
> > It was reported Friday evening, on a holiday weekend for some of us, we
> > are trying the best we can :)
> >
> >> Especially since it is in a branch that is supposedly "bug fixes"?
> >
> > It fixes up a reported problem, and we had 3 people test it and said it
> > resolved the issue for them, no build problems reported.
> >
> > Randy, can I get a copy of your .config that duplicates this?
> 
> I looked at it, and did not see it, I was blind.
> 
> We just miss the "static inline" in include/linux/kmsg_dump.h. :)

From: Kay Sievers <kay@vrfy.org>
Subject: kmsg - kmsg_dump() fix CONFIG_PRINTK=n compilation

Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 include/linux/kmsg_dump.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -71,19 +71,19 @@ static inline void kmsg_dump(enum kmsg_d
 {
 }
 
-bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
-			  const char *line, size_t size, size_t *len)
+static inline bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
+				const char *line, size_t size, size_t *len)
 {
 	return false;
 }
 
-bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
-			    char *buf, size_t size, size_t *len)
+static inline bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
+					char *buf, size_t size, size_t *len)
 {
 	return false;
 }
 
-void kmsg_dump_rewind(struct kmsg_dumper *dumper)
+static inline void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 {
 }
 

