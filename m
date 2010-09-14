Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0INUG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:06:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776Ab0INUG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:06:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
 <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Sep 2010 13:05:34 -0700
Message-ID: <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 1:00 PM, David Rientjes <rientjes@google.com> wrote:
>
> I can understand how it's confusing that only the first slab cache name is
> being emitted, and I think that can be changed, but this shows way too
> much information that is already available when CONFIG_SLUB_DEBUG is used
> via the sysfs interface.

Umm. Not in any readable form, it isn't.

The cause for this is that I made a bug-report about the wrong slab
info, with me claiming 400+ thousand entries (taking up 10M of memory)
for a slub cache that turned out to be entirely innocent.

That's what /proc/slabinfo said, and quite frankly, /proc/slabinfo was
simply _lying_. It gave very misleading output.

In my not-so-humble opinion, either the merging needs to go away
entirely, or the misleading output needs to be fixed. The whole (and
_only_) reason for /proc/slabinfo is to show where memory is being
used, so if that file is misleading, then it's worse than useless.
Pointing to some other /sys file as having more information doesn't
change that in the least.

                        Linus
