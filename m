Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0H0H5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:57:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0H0H5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:57:45 -0400
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100827055105.GA3857@amd>
References: <20100825132815.108d8217@bike.lwn.net>
	 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
	 <4C762BF9.5010305@kernel.org> <20100826094613.GA6411@amd>
	 <4C7638B7.9060306@kernel.org> <1282817329.1975.486.camel@laptop>
	 <20100826113858.GA6856@amd> <1282823139.1975.689.camel@laptop>
	 <20100827055105.GA3857@amd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 09:57:36 +0200
Message-ID: <1282895856.1975.1711.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 15:51 +1000, Nick Piggin wrote:
> 
> I don't see what is so nice about stop_machine()less cpu plug/unplug
> or module unload. Module load definitely is nice because you can
> have a lot of modules and on demand loading from non-privileged
> operations. 

There's a large three lettered company that's promoting cpu hotplug use
for power management, they hotplug at an astonishing rate.

I've been saying hotplug isn't for that, and its a terrible slow path
and disrupts your whole machine etc.. they don't seem to care much.

The trouble seems to be that some smaller chips are now also wanting to
use hotplug for PM because they want to safe silicon and not make their
chips symmetric or crap like that...

Its all really sad, and I'd prefer to keep hotplug slow and simple and
simply never use it except when you like suspend your laptop -- but even
there, people want auto-demand suspend crazy lot.
