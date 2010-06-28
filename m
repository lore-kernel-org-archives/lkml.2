Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0F1WzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 18:55:07 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42415 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0F1WzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 18:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=egPHeilKGiBL8tyN9lh9JsdE588z1EFRfYLe297KjaVBXfKOVk0ZNRUE8OVdUcvD6E
         116jJKw7GstT1XXyIe82fH9Xeu7egxy1xbfp+Ow/aMFR6nmgNGk9Qb7OUwNmGKDGyRYl
         7mbSg31XzlpozS4ZPyXm93JUs8tUbxwMUEjDs=
Date: Tue, 29 Jun 2010 00:55:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
Message-ID: <20100628225513.GB10104@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277759063-24607-35-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:04:22PM +0200, Tejun Heo wrote:
> Replace private worker pool with system_long_wq.


It appeared to me that async is deemed to parallelize as much as
possible, to probe devices faster on boot for example, while cmwq
seems to do the opposite: trying to execute in batches as much as
possible, and fork when a work goes to sleep voluntarily.

That said I haven't checked that deeply so it's fairly possible
I missed something obvious :)

