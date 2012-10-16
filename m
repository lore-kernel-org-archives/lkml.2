Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2JPSsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:48:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2JPSsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:48:00 -0400
Date: Tue, 16 Oct 2012 11:47:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, Avleen Vig <avleen@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reading /proc/slabinfo causes stalls
In-Reply-To: <0000013a6ad64c95-106bab18-5a15-4c85-bae9-5527aa52f661-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1210161147410.2910@chino.kir.corp.google.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com> <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com> <0000013a6ad64c95-106bab18-5a15-4c85-bae9-5527aa52f661-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Christoph Lameter wrote:

> If the allocator is SLAB then I would think that this is a stall of
> slabinfo mutex vs. slab clean operations (gets more frequent the more
> processors are in the box).
> 
> If this is the case then using the SLUB allocator will fix the issue since
> SLUB does not need to perform cache cleaning.
> 

Or convert slab_mutex to be a rwlock?
