Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab2FAMSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:18:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34357 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759511Ab2FAMSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206010934460.2163@tux.localdomain>
References: <1336665378-2967-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1205142332060.19403@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1205311351540.2764@chino.kir.corp.google.com>
	<alpine.LFD.2.02.1206010934460.2163@tux.localdomain>
Date: Fri, 1 Jun 2012 21:18:23 +0900
Message-ID: <CAAmzW4PYMExvnCPjLphEOCiqjGMy6TxVQCtvQdW8tew4kNQ0uw@mail.gmail.com>
Subject: Re: [PATCH] slub: change cmpxchg_double_slab in get_freelist() to __cmpxchg_double_slab
From: JoonSoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We now made get_freelist() *require* interrupts to be disabled which
> deserves a comment, no?

I resend patch(18 May) related to this comment.
See below link.
http://thread.gmane.org/gmane.linux.kernel.mm/78630/focus=78701

> Also, what do we gain from patches like this? It's somewhat
> counterintuitive that we have a function with "cmpxchg" in it which is not
> always atomic (i.e. you need to have interrupts disabled).

Hmm...
This patch have a minor impact which saves a few instructions.
But we already have a "__cmpxchg" version which works in irq disabled,
so there is no reason for not applying it.
