Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1GGSwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:52:55 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:44881 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1GGSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:52:53 -0400
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, rientjes@google.com,
        linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1107071314320.21719@router.home>
References: <20110626193918.GA3339@joi.lan>
	 <alpine.DEB.2.00.1107072106560.6693@tiger>
	 <alpine.DEB.2.00.1107071314320.21719@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Jul 2011 21:52:51 +0300
Message-ID: <1310064771.21902.55.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Pekka Enberg wrote:
> > Looks good to me. Christoph, David, ?

On Thu, 2011-07-07 at 13:17 -0500, Christoph Lameter wrote:
> The reason debug code is there is because it is useless overhead typically
> not needed. There is no point in optimizing the code that is not run in
> production environments unless there are gross performance issues that
> make debugging difficult. A performance patch for debugging would have to
> cause significant performance improvements. This patch does not do that
> nor was there such an issue to be addressed in the first place.

Is there something technically wrong with the patch? Quoting the patch
email:

  (Compiling some project with different options)
                                 make -j12    make clean
  slub_debug disabled:             1m 27s       1.2 s
  slub_debug enabled:              1m 46s       7.6 s
  slub_debug enabled + this patch: 1m 33s       3.2 s

  check_bytes still shows up high, but not always at the top.

That's significant enough speedup for me!

			Pekka

