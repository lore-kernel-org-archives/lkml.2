Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0EELKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:10:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0EELKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:10:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100505104807.GB32643@google.com>
References: <20100505104807.GB32643@google.com> <20100505032033.GA19232@google.com> <22994.1273054004@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwsem: down_read_unfair() proposal
Date: Wed, 05 May 2010 12:09:59 +0100
Message-ID: <23977.1273057799@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> I only said it was doable :) Not done with the implementation yet, but I can
> describe the general idea if that helps. The high part of the rwsem is
> decremented by two for each thread holding or trying to acquire a write
> lock;

That would mean you're reducing the capacity of the upper counter by one since
the high part must remain negative if we're to be able to check it for
non-zeroness by checking the sign flag.  That means a maximum of 2^14-1 writers
queued on a 32-bit box (16384), but we can have more threads than that (up to
~32767).

Currently, we can have a maximum of 32767 writers+readers queued as we only
decrement the upper counter by 1 each time.

On a 64-bit box, the limitations go away for all practical purposes.

David
