Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab0KOWtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:49:18 -0500
Received: from fep19.mx.upcmail.net ([62.179.121.39]:34182 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab0KOWtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:49:17 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1289856350.14719.135.camel@maggy.simson.net>
References: <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
	 <20101114202734.GA1627@arch.trippelsdorf.de>
	 <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 23:48:37 +0100
Message-ID: <1289861317.24491.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=Nww7yNiXF4C1XGF+VcigPkOcTpD8wJaI1KQuZlH5eEk= c=1 sm=0 a=HQdU9CJ4CokA:10 a=IkcTkHD0fZMA:10 a=aG11du2c5PL_wI7MKosA:9 a=YAKJ2UuutuYXfpVz5FXrHO8Qy-0A:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 14:25 -0700, Mike Galbraith wrote:
> > However. Currently the only callers holds ->siglock, so we are safe.
> > Perhaps we should just document that autogroup_move_group() needs
> > ->siglock.
> 
> Done. 

lockdep_assert_held() is a good way to document these things.

