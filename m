Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1HVPUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:20:36 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:59615 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752977Ab1HVPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:20:30 -0400
Subject: Re: [PATCH 14/14] [media] gspca: Use current logging styles
From: Joe Perches <joe@perches.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110822105003.0002ef3c@tele>
References: <cover.1313966088.git.joe@perches.com>
	 <9927bff9b5f212dcbe867a9f882e53ed80bd9a0f.1313966090.git.joe@perches.com>
	 <20110822105003.0002ef3c@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 08:20:28 -0700
Message-ID: <1314026428.18461.10.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 10:50 +0200, Jean-Francois Moine wrote:
> On Sun, 21 Aug 2011 15:56:57 -0700
> Joe Perches <joe@perches.com> wrote:
> > Add pr_fmt.
> > Convert usb style logging macros to pr_<level>.
> > Remove now unused old usb style logging macros.
> Hi Joe,

Hello Jean-Francois.

> Sorry, but I do not see the advantages of your patch.

The primary current advantage is style standardization
both in code and dmesg output.

Future changes to printk.h will reduce object sizes
by centralizing the prefix to a singleton and
emitting it only in pr_<level>.

> For gspca, the source files are bigger, and the only visible change is
> the display of the real module name instead of the name defined by hand
> (this change may have been done just in gspca.h).

No, not really. gspca.h is not the first #include
for all sources.

Using #define pr_fmt before any #include avoids
possible redefinition of the pr_<level> prefix.

$ grep -rP --include=*.[ch] -l "gspca\.h" drivers/media | \
	xargs grep -m1 "#\s*include"

> Also, I think that defining 'pr_fmt' in each source file is not a good
> idea...

That's temporary for another year or so.
After changes to printk are introduced, all
of the uses of
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
could/should be removed.

cheers, Joe


