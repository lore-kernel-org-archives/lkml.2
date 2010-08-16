Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0HPTeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:34:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab0HPTeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:34:03 -0400
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and
 the implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: paulmck@us.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adurbin@google.com
In-Reply-To: <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
References: <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 21:33:56 +0200
Message-ID: <1281987236.1926.1895.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 11:30 -0700, Salman Qazi wrote:
> For the delete case,
> we no longer shrink the tree back to being just the root containing the
> only remaining object.  For the insert case, we no longer store the
> first object in the root, rather allocating a node structure for it.  The
> reason that this works is that deleting (or inserting) intermediate nodes
> does not make a difference to a reader holding a slot.  

Ah, I through that was what it did. So you basically increase the memory
footprint for tiny files.. have you done any measurements on that?
