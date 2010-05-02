Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0EBCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 22:09:59 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44462 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0EBCJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 22:09:58 -0400
Date: Sat, 1 May 2010 21:06:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] - New round-robin rotor for SLAB allocations
In-Reply-To: <20100430135239.7782f6ba.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1005012103360.2928@router.home>
References: <20100426210041.GA6580@sgi.com> <20100430135239.7782f6ba.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Andrew Morton wrote:

> Why no update to slob and slub?

SLUB does not do things like managing object level NUMAness but relies on
the page allocator to spread page size blocks out. It will only use one
rotor and therefore not skip nodes. The SLAB issues are a result of the
way object level NUMA awareness is implemented there.

SLOB also does not do the SLAB thing and defers to the page allocator.



