Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0DAJnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:43:00 -0400
Received: from mail2.shareable.org ([80.68.89.115]:34508 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0DAJmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:42:53 -0400
Date: Thu, 1 Apr 2010 10:41:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100401094111.GB29433@shareable.org>
References: <20100331210555.GA17715@flint.arm.linux.org.uk> <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <19680.1270076318@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19680.1270076318@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Russell King <rmk@arm.linux.org.uk> wrote:
> > We use the standard generic kernel implementation.  Is x86 different? ;)
> 
> The optimised fast paths used on x86 rwsems don't disable interrupts.

Any reason not to use the same technique for all the archs - plus the
trick used in arch/armkernel/entry-armv.S:__kuser_cmpxchg for those
archs which don't have atomic instructions or ll/sc?

If the problem here is _only_ semaphores, and the above might make
semaphores faster anyway, perhaps it's a solution.

-- Jamie
