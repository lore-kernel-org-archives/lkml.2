Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab0CXTQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:16:23 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:59869 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0CXTQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:16:21 -0400
Date: Wed, 24 Mar 2010 14:16:01 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Potential stack overflow
In-Reply-To: <1269430856.3213.27.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1003241414270.14329@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Eric Dumazet wrote:

> I discovered that we can overflow stack if CONFIG_SLUB_DEBUG=y and use
> slabs with many objects, since list_slab_objects() and process_slab()
> use DECLARE_BITMAP(map, page->objects);

Maybe we better allocate the bitmap via kmalloc then.

