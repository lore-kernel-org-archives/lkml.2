Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1CPSR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:17:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39048 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1CPSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:17:22 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-reply-to: <AANLkTinC2i_+kBjRNFsf8fCKMWJ1zvxAf-A9rf+ZGt-y@mail.gmail.com>
	(message from Linus Torvalds on Wed, 16 Mar 2011 10:42:59 -0700)
Subject: Re: [git pull] several fixes
References: <20110316144253.GT22723@ZenIV.linux.org.uk> <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu> <AANLkTinC2i_+kBjRNFsf8fCKMWJ1zvxAf-A9rf+ZGt-y@mail.gmail.com>
Message-Id: <E1PzvHb-0006x5-IF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Mar 2011 19:17:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Linus Torvalds wrote:
> On Wed, Mar 16, 2011 at 10:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > __fput doesn't need a cdev_put() for O_PATH handles.
> 
> "doesn't need" or "must not have"?

It must not have one, otherwise refcounting will go astray.

That cdev_put() should really be moved into f_op->release(), but that
would be quite a bit of work.

Thanks,
Miklos
