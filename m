Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab1KVUki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:40:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56432 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab1KVUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:40:37 -0500
MIME-Version: 1.0
Date: Wed, 23 Nov 2011 04:40:36 +0800
Message-ID: <CABexPfF-31f1vcJpqdsDHKUHfes1230vwGMtm6ETZXVQQf4bcA@mail.gmail.com>
Subject: Slub Allocator: Why get_order(size * MAX_OBJS_PER_PAGE) - 1 in
 function slab_order()?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone,
        I'm reading the kernel codes about slub allocator and I come
across a confusion. Precisely, I'm reading the initialization of the
slub allocator, kmem_cache_init(), and I find it needs call
calculate_sizes() to determine the order of a kmem_cache, given the
size of the object. In turn, it calls the get_order() to get a
possible order. The problem is, in the start of this function, why it
looks like this:

        if (order_objects(min_order, size, reserved) > MAX_OBJS_PER_PAGE)
                return get_order(size * MAX_OBJS_PER_PAGE) - 1;

        I don't know why it subtracts one from the order returned by
get_order().
        because as far as I know, get_order() returns the order the
slab requires to reserve size * MAX_OBJS_PER_PAGE memory. If it
subtracts 1 from the order returned by get_order(), the slab can't
store MAX_OBJS_PER_PAGE objects at all, instead it can only store half
of the MAX_OBJS_PER_PAGE objects.
        Could you correct me if I think in a wrong way.
