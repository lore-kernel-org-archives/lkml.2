Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0KYPJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:09:51 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:52272 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0KYPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:09:50 -0500
From: nisse@lysator.liu.se (Niels =?iso-8859-1?Q?M=F6ller?=)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
References: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
	<1290695253.2858.336.camel@edumazet-laptop>
Date: Thu, 25 Nov 2010 16:09:49 +0100
In-Reply-To: <1290695253.2858.336.camel@edumazet-laptop> (Eric Dumazet's
	message of "Thu, 25 Nov 2010 15:27:33 +0100")
Message-ID: <nnaakxqw1u.fsf@stalhein.lysator.liu.se>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (usg-unix-v)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> So... there is no 'bug', unless you trust too much tcpdump output.

I really expected tcpdump -e to display the actual values in the link
layer header, including the correct frame size. It's more than a bit
confusing if that is not the case...

In the future, I will try to remember to always run tcpdump on a network
node which (i) is different from the sending one, and (ii) has GRO
disabled (and hence will discard packets if it has trouble processing
them all, rather than coalesce them).

What about the TCP_MAXSEG socket option, should that work? From a quick
look at driver source code, I could only see the handling of the
per-interface MTU, no per-socket segment size.

Thanks for the quick reply,
/Niels

-- 
Niels Möller. PGP-encrypted email is preferred. Keyid C0B98E26.
Internet email is subject to wholesale government surveillance.
