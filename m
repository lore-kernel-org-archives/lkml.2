Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2HPKGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:06:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab2HPKGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:06:05 -0400
Date: Thu, 16 Aug 2012 12:05:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (hid
 tree related)
In-Reply-To: <20120816152538.7f850ee1a3b8ce90d9f749a2@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1208161204520.7026@pobox.suse.cz>
References: <20120816152538.7f850ee1a3b8ce90d9f749a2@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Stephen Rothwell wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/hid/hid-picolcd_fb.c: In function 'picolcd_fb_destroy':
> drivers/hid/hid-picolcd_fb.c:350:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
> drivers/hid/hid-picolcd_fb.c: In function 'picolcd_init_framebuffer':
> drivers/hid/hid-picolcd_fb.c:508:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
> drivers/hid/hid-picolcd_fb.c:508:12: warning: assignment makes pointer from integer without a cast [enabled by default]
> 
> Caused by commit fabdbf2fd22f ("HID: picoLCD: split driver code") from
> the hid tree.

Hmm, seems config dependent, doesn't trigger here. Probably vmalloc.h gets 
sucked in some other way under certain config options.

Anyway I have now applied your patch Stephen, so you should be able to 
drop it from your pile.

Thanks,

-- 
Jiri Kosina
SUSE Labs
