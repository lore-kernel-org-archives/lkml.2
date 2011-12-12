Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1LLWML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:12:11 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42578 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab1LLWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:12:06 -0500
X-Sasl-enc: s31Qyhpqbo+BPbOvZPnVV6ERQnCmcZqvpedgT7yTjLXM 1323727924
Date: Mon, 12 Dec 2011 14:11:59 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Subject: Re: [PATCH 1/3] kref: Inline all functions
Message-ID: <20111212221159.GA27940@kroah.com>
References: <20111210104341.592561407@chello.nl>
 <20111210104840.107647845@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111210104840.107647845@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 11:43:42AM +0100, Peter Zijlstra wrote:
> These are tiny functions, there's no point in having them out-of-line.

Nice, but this breaks the build:

  CC      init/main.o
In file included from include/linux/kobject.h:24:0,
                 from include/linux/module.h:16,
                 from init/main.c:13:
include/linux/kref.h: In function ‘kref_put’:
include/linux/kref.h:62:2: error: ‘kfree’ undeclared (first use in this function)
include/linux/kref.h:62:2: note: each undeclared identifier is reported only once for each function it appears in
include/linux/kref.h: In function ‘kref_sub’:
include/linux/kref.h:91:2: error: ‘kfree’ undeclared (first use in this function)
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

Sorry, I can't apply this.

This was on an x86-64 build, my "stock" desktop system, nothing "odd" in the
config at all...

greg k-h
