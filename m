Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab2C3S6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:58:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54186 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2C3S6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:58:19 -0400
Subject: Re: [REGRESSION][PATCH V4 2/3] bpf jit: Let the x86 jit handle
 negative offsets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4F75D015.30609@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	 <4F75D015.30609@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 20:58:00 +0200
Message-ID: <1333133880.2325.2430.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 17:24 +0200, Jan Seiffert wrote:
> Now the helper function from filter.c for negative offsets is exported,
> it can be used it in the jit to handle negative offsets.
> 
> First modify the asm load helper functions to handle:
> - know positive offsets
> - know negative offsets
> - any offset
> 
> then the compiler can be modified to explicitly use these helper
> when appropriate.
> 
> This fixes the case of a negative X register and allows to lift
> the restriction that bpf programs with negative offsets can't
> be jited.
> 
> Signed-of-by: Jan Seiffert <kaffeemonster@googlemail.com>

Nice work Jan, thanks a lot.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>



