Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0LHEhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:37:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50485 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0LHEhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r3YkO1udObnCrGzWb4E9JTwBdYUJlh/JfaQKWrle9dggQpv6YJRe+kivmQEFreqHV1
         IQPKYP349t3IAiMNTjOZMPJPQkG7gwkwwcF3mSB972wd4qvSbOE02qDDX4LQaEYRYNGo
         HofrVB3nyLYLD6hL+2MLFE2HJZ4WKVd2yNMP4=
Subject: Re: [06/44] numa: fix slab_node(MPOL_BIND)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <20101208041725.GB2291@suse.de>
References: <20101208000640.115606851@clark.site>
	 <1291777422.26147.70.camel@zaphod>  <20101208041725.GB2291@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 05:37:06 +0100
Message-ID: <1291783026.5324.56.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 décembre 2010 à 20:17 -0800, Greg KH a écrit :
> On Tue, Dec 07, 2010 at 10:03:42PM -0500, Lee Schermerhorn wrote:
> > 
> > I think this should be numa_mem_id().  Given the documented purpose of
> > slab_node(), we want a node from which page allocation is likely to
> > succeed.  numa_node_id() can return a memoryless node for, e.g.,  some
> > configurations of some HP ia64 platforms.  numa_mem_id() was introduced
> > to return that same node from which "local" mempolicy would allocate
> > pages.
> 
> So should the upstream patch be changed?

We certainly can convert most numa_node_id() calls to numa_mem_id()
ones, but it wont be backported to 2.6.32, 2.6.34 & 2.6.27 :)


