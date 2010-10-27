Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0J0TtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:49:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52281 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0J0TtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:49:08 -0400
Date: Wed, 27 Oct 2010 15:49:05 -0400
From: Nelson Elhage <nelhage@ksplice.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, robert.olsson@its.uu.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eugene@redhat.com
Subject: Re: [PATCH] pktgen: Remove a dangerous debug print.
Message-ID: <20101027194905.GQ16803@ksplice.com>
References: <1288206788-21063-1-git-send-email-nelhage@ksplice.com>
 <20101027.122143.02260950.davem@davemloft.net>
 <20101027192808.GP16803@ksplice.com>
 <1288208499.2658.19.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288208499.2658.19.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested this and was able to oops both amd64 and i386 test machines with 8k
writes to the pktgen file. I haven't investigated whether that's because there's
no PAGE_SIZE limit, or because one page ends up being enough to cause a problem
on all my test machines.

- Nelson

On Wed, Oct 27, 2010 at 09:41:39PM +0200, Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 à 15:28 -0400, Nelson Elhage a écrit :
> > How would you feel about limiting the debug print to at most, say, 512 or 1024
> > bytes? Even if it's only accessible to root by default, I don't a userspace
> > program should be able to accidentally corrupt the kernel stack by writing too
> > many bytes to a file in /proc.
> 
> Arent /proc writes limited to PAGE_SIZE anyway ?
> 
> On x86 at least, you cannot corrupt kernel stack, since its bigger than
> PAGE_SIZE.
> 
> I agree pktgen code is a bit ugly and needs a cleanup, but who
> cares ? :)
> 
> 
> 
> 
