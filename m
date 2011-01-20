Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1ATWWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:22:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab1ATWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:22:36 -0500
MIME-Version: 1.0
In-Reply-To: <1295559646.2613.35.camel@edumazet-laptop>
References: <20110119.180418.216749267.davem@davemloft.net>
 <AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com> <1295559646.2613.35.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jan 2011 14:21:43 -0800
Message-ID: <AANLkTikLY1B3=C2TjAbYKVHbub-aPeG2heaUBWRUAg=R@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 1:40 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Then here ask for fd=3 both POLLIN and POLLOUT :
> kernel answers : OK for POLLOUT (not POLLIN), so previous poll() call
> was OK to be blocked after all...
>
> So I'm wondering if it could be a userland bug, that triggers with
> recent kernel changes.

As far as I can tell, that program isn't multi-threaded, and it should
not have returned to user land at all (no signal, and a restart). So I
think it's a kernel-only thing - there should have been nothing that
could have changed the poll list in user space. But I didn't really
check the threading status.

I'm trying to bisect it now to figure out more hints.

             Linus
