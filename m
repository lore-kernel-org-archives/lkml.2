Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1CIVUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:20:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:52095 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1CIVUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:20:43 -0500
Subject: Re: [PATCH/v2] mm/memblock: Properly handle overlaps and fix error
 path
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>
In-Reply-To: <4D77E5E0.6010706@kernel.org>
References: <1299466980.8833.973.camel@pasglop>
	 <4D77E5E0.6010706@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 08:20:10 +1100
Message-ID: <1299705610.22236.390.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 12:41 -0800, Yinghai Lu wrote:
> > Hopefully not damaged with a spurious bit of email header this
> > time around... sorry about that.
> 
> works on my setups...
> 
> [    0.000000] Subtract (26 early reservations)
> [    0.000000]   [000009a000-000009efff]
> [    0.000000]   [000009f400-00000fffff]
> [    0.000000]   [0001000000-0003495048]
> ...
> before:
> [    0.000000] Subtract (27 early reservations)
> [    0.000000]   [000009a000-000009efff]
> [    0.000000]   [000009f400-00000fffff]
> [    0.000000]   [00000f85b0-00000f86b3]
> [    0.000000]   [0001000000-0003495048] 

Ah interesting, so you did have a case of overlap that wasn't properly
handled as well.

If there is no objection, I'll queue that up in powerpc-next for the
upcoming merge window (soon now).

Cheers,
Ben.


