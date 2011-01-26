Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1AZCAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 21:00:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64333 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1AZCAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 21:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OllnSP/0IfZSopwxnSAHYE7Wq94zYibxotm0ON2GUrdMJpi+2O5TPjJ/ehj/CIQktj
         fTkOE8ryD6L9PzM8psGEByCVXjtjbhVnJhYUBIXaf5/zUpuecaoEXUzn1lZbnM/OdHdc
         Qa4ImoSDFc1zmwqizx28B3i99pY5YJTrfhUBA=
Date: Tue, 25 Jan 2011 18:00:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126020003.GA23085@core.coreip.homeip.net>
References: <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net>
 <4D3EB734.5090100@redhat.com>
 <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125232914.GA20130@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:29:14PM -0800, Dmitry Torokhov wrote:
> On Tue, Jan 25, 2011 at 05:22:09PM -0500, Mark Lord wrote:
> > On 11-01-25 05:00 PM, Mauro Carvalho Chehab wrote:
> > > Em 25-01-2011 18:54, Dmitry Torokhov escreveu:
> > >> On Wed, Jan 26, 2011 at 06:09:45AM +1000, Linus Torvalds wrote:
> > >>> On Wed, Jan 26, 2011 at 2:48 AM, Dmitry Torokhov
> > >>> <dmitry.torokhov@gmail.com> wrote:
> > >>>>
> > >>>> We should be able to handle the case where scancode is valid even though
> > >>>> it might be unmapped yet. This is regardless of what version of
> > >>>> EVIOCGKEYCODE we use, 1 or 2, and whether it is sparse keymap or not.
> > >>>>
> > >>>> Is it possible to validate the scancode by driver?
> > >>>
> > >>> More appropriately, why not just revert the thing? The version change
> > > 
> > > Reverting the version increment is a bad thing. I agree with Dmitry that
> > > an application that fails just because the API version were incremented
> > > is buggy.
> > > 
> > >> Well, then we'll break Ubuntu again as they recompiled their input-utils
> > >> package (without fixing the check). And the rest of distros do not seem
> > >> to be using that package...
> > > 
> > > Reverting it will also break the ir-keytable userspace program that it is
> > > meant to be used by the Remote Controller devices, and uses it to adjust
> > > its behaviour to support RC's with more than 16 bits of scancodes.
> > > 
> > > I agree that it is bad that the ABI broke, but reverting it will cause even
> > > more damage.
> > 
> > There we disagree.  Sure it's a very poorly thought out interface,
> > but the way to fix it is to put a new one along side the old,
> > and put the old back the way it was before it got broken.
> > 
> > I'm not making a fuss here for myself -- I'm more than capable of working
> > around new kernel bugs like these, but for every person like me there are
> > likely hundreds of others who simply get frustrated and give up.
> > 
> > If you're worried about Ubuntu's adaptation to the buggy regression,
> > then email their developers (kernel and input-utils packagers) explaining
> > the revert, and they can coordination their kernel and input-utils updates
> > to do the Right Thing.
> > 
> > But for all of the rest of us, our systems are broken by this change.
> > 
> > ...
> > 
> > 
> > >>> As Mark said, breaking user space simply isn't acceptable. And since
> > >>> breaking user space isn't acceptable, then incrementing the version is
> > >>> stupid too.
> > >>
> > >> It might not have been the best idea to increment, however I maintain
> > >> that if there exists version is can be changed. Otherwise there is no
> > >> point in having version at all.
> > > 
> > > Not arguing in favor of the version numbering, but it is easy to read
> > > the version increment at the beginning of the application, and adjust
> > > if the code will use EVIOCGKEYCODE or EVIOCGKEYCODE_V2 of the ioctl's,
> > > depending on what kernel provides.
> > > 
> > > Ok, we might be just calling the new ioctl and check for -ENOSYS at
> > > the beginning, using some fake arguments.
> > > 
> > >> As I said, reverting the version bump will cause yet another wave of
> > >> breakages so I propose leaving version as is.
> > >>
> > >>>
> > >>> The way we add new ioctl's is not by incrementing some "ABI version"
> > >>> crap. It's by adding new ioctl's or system calls or whatever that
> > >>> simply used to return -ENOSYS or other error before, while preserving
> > >>> the old ABI. That way old binaries don't break (for _ANY_ reason), and
> > >>> new binaries can see "oh, this doesn't support the new thing".
> > >>
> > >> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
> > 
> > That's the problem: you did NOT keep the two old ioctls().
> > Those got changed too.. so now we have four NEW ioctls(),
> > none of which backward compatible with userspace.
> > 
> 
> Please calm down. This, in fact, is not new vs old ioctl problem but
> rather particular driver (or rather set of drivers) implementation
> issue. Even if we drop the new ioctls and convert the RC code to use the
> old ones you'd be observing the same breakage as RC code responds with
> -EINVAL to not-yet-established mappings.
> 
> I'll see what can be done for these drivers; I guess we could supply a
> fake KEY_RESERVED entry for not mapped scancodes if there are mapped
> scancodes "above" current one. That should result in the same behavior
> for RCs as before.
> 

I wonder if the patch below is all that is needed...

Thanks!

-- 
Dmitry


Input: ir-keymap - return KEY_RESERVED for unknown mappings

Do not respond with -EINVAL to EVIOCGKEYCODE for not-yet-mapped scancodes,
but rather return KEY_RESERVED.

This fixes breakage with Ubuntu's input-kbd utility that stopped returning
full keymaps for remote controls.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/media/IR/ir-keytable.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)


diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index f60107c..c4645d7 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -374,21 +374,27 @@ static int ir_getkeycode(struct input_dev *dev,
 		index = ir_lookup_by_scancode(rc_tab, scancode);
 	}
 
-	if (index >= rc_tab->len) {
-		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
-			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-				   scancode);
+	if (index < rc_tab->len) {
+		entry = &rc_tab->scan[index];
+
+		ke->index = index;
+		ke->keycode = entry->keycode;
+		ke->len = sizeof(entry->scancode);
+		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+
+	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
+		/*
+		 * We do not really know the valid range of scancodes
+		 * so let's respond with KEY_RESERVED to anything we
+		 * do not have mapping for [yet].
+		 */
+		ke->index = index;
+		ke->keycode = KEY_RESERVED;
+	} else {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	entry = &rc_tab->scan[index];
-
-	ke->index = index;
-	ke->keycode = entry->keycode;
-	ke->len = sizeof(entry->scancode);
-	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
-
 	retval = 0;
 
 out:
