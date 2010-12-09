Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0LII6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:58:23 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:36562 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0LII6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:58:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oMa5c4HiLisjA0p86JunlhYUBVvfzHfEqeBHw7Qtqtd4tDNp8k59c1miiMx3iZScD/
         pR+jOfyAs47Lft+mAdsBRV0gjboclvrRdneUP9pi2xbfXX/iSPZUv9qbOrlTAoC7mv1n
         U1toB/6JEq7ZnQbU8iR/98ZWe/i4sxps5gHHo=
Date: Thu, 9 Dec 2010 00:58:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
Message-ID: <20101209085814.GA8821@core.coreip.homeip.net>
References: <4CFF49BC.8030202@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFF49BC.8030202@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 10:02:52AM +0100, Henrik Rydberg wrote:
> Dmitry,
> 
> Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next
> 
> to receive input-mt updates for 2.6.38.
> 
> The tree contains core changes as well as dependent changes to hid drivers. You
> also find the new hid-egalax driver in there, signed off by Jiri.

Pulled, thank you Henrik.

I wonder if we should move input-mt.h into input/mt.h (and if someone
would bother to input-polldev.h there that would be great too).

Also I try to sync with mainline once per release, at -rc1, unless I
know that my changes will conflict with some other work. I'd recommend
you do the same so that when I pull from you I am getting just your
changes and not the rest of stuff from mainline.

BTW, we need to document dev->trkid to avoid complaints from 'make
htmldocs' and friends. I wonder if the patch below will do.

Thanks.

-- 
Dmitry


Input: document new trkid field in struct input_dev

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 include/linux/input.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/include/linux/input.h b/include/linux/input.h
index 6914269..56bf497 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1182,6 +1182,7 @@ struct ff_effect {
  *	of tracked contacts
  * @mtsize: number of MT slots the device uses
  * @slot: MT slot currently being transmitted
+ * @trkid: stores MT tracking ID for the current contact
  * @absinfo: array of &struct input_absinfo elements holding information
  *	about absolute axes (current value, min, max, flat, fuzz,
  *	resolution)
