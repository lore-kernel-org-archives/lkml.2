Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab2GYPTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:19:44 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:14171
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933187Ab2GYPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:19:43 -0400
X-IronPort-AV: E=Sophos;i="4.77,653,1336341600"; 
   d="scan'208";a="151670789"
Date: Wed, 25 Jul 2012 17:19:40 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Coccinelle <cocci@diku.dk>,
        Nicolas Palix <npalix@diku.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] coccinelle hung on mini_lock.cocci
In-Reply-To: <20120725145011.GA1787@localhost>
Message-ID: <alpine.DEB.2.02.1207251717300.1818@hadrien>
References: <20120725114216.GA26741@localhost> <alpine.DEB.2.02.1207251613420.1818@hadrien> <20120725141844.GA761@localhost> <alpine.DEB.2.02.1207251641280.1818@hadrien> <20120725145011.GA1787@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked at it a bit more, and I think the timeout is the best solution.
The big jump backwards is under an if, and the pattern tries to match an
if up to a return, which tries to go across gotos.  So I think it is just
a pathologically bad case.

julia
