Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2K2TUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:20:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2K2TUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:20:04 -0500
Date: Thu, 29 Nov 2012 20:20:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129192003.GX16230@one.firstfloor.org>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com> <1354121029-1376-23-git-send-email-koverstreet@google.com> <m28v9kgsen.fsf@firstfloor.org> <20121129185720.GE15094@google.com> <20121129185953.GW16230@one.firstfloor.org> <20121129191214.GG15094@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129191214.GG15094@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The trick is that we don't watch for the refcount hitting 0 until we're
> shutting down - so this only works if you keep track of your initial
> refcount. As long as we're not shutting down, we know the refcount can't
> hit 0 because we haven't released the initial refcount.

This seems dangerous to me: assume you have one CPU which always
does get and another does put. So there may be 2^32 such operations
without a kill and you wrap for real in a way that does not get
corrected.

Normally this can only happen if you have a lot of objects or CPUs
are limited.

But you don't have any limit on getting out-of-sync. 

You could make it 64bit, but then wraps could happen.

-Andi
