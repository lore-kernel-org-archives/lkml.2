Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0CXTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:22:18 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42541 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854Ab0CXTWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rSbBlJh62gPo8gl0FB1OmaNx4J8kh6ZrGxaDQ21md2Mep73VXNyEzC3qxrBnDUBqgj
         8r3HcpL1rA5SnqqKeZFtQ7IjCjbRfn+GmXHOzN0tVapyC08veT0SUiDqmeNWA6n+A4lk
         hVsVdJNhSUI9EXHiDxhgLhmn58NQ3E+mcEyDw=
Subject: Re: [PATCH] slub: Potential stack overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1003241414270.14329@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1003241414270.14329@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 20:22:08 +0100
Message-ID: <1269458528.2849.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 mars 2010 à 14:16 -0500, Christoph Lameter a écrit :
> On Wed, 24 Mar 2010, Eric Dumazet wrote:
> 
> > I discovered that we can overflow stack if CONFIG_SLUB_DEBUG=y and use
> > slabs with many objects, since list_slab_objects() and process_slab()
> > use DECLARE_BITMAP(map, page->objects);
> 
> Maybe we better allocate the bitmap via kmalloc then.
> 

Hmm...

Are we allowed to nest in these two functions ?

GFP_KERNEL, GFP_ATOMIC ?

These are debugging functions, what happens if kmalloc() returns NULL ?



