Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1KNPyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:54:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45430 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1KNPyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:54:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net>
Date: Mon, 14 Nov 2011 10:54:01 -0500
Message-ID: <CAAsGZS7sPYqXi+KxjD9omzvDME6A3SFGv+kMadMhJk6qNtSsBw@mail.gmail.com>
Subject: Re: [PATCH] net/packet: remove dead code and unneeded variable from prb_setup_retire_blk_timer()
From: chetan loke <loke.chetan@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Ben Greear <greearb@candelatech.com>, waltje@uwalt.nl.mugnet.org,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 4:55 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> We test for 'tx_ring' being != zero and BUG() if that's the case. So after
> that check there is no way that 'tx_ring' could be anything _but_ zero, so
> testing it again is just dead code. Once that dead code is removed, the
> 'pkc' local variable becomes entirely redundant, so remove that as well.

It was there so that it would be a no-brainer thing for the next
person who would want to enable tx_ring support. And given that this
check was called just once during the initial setup, it didn't seem
like a big deal to me. And the BUG() would let the next-person know
what different paths need to be plugged.


Chetan Loke
