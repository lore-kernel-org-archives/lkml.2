Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab0GPJ7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:59:45 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:56973 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964895Ab0GPJ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:59:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19520.11654.346814.433232@pilspetsen.it.uu.se>
Date: Fri, 16 Jul 2010 11:59:34 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: anonymous mmap() and random heap allocation
In-Reply-To: <AANLkTilDmFF4IN1Glo_Bv_-eBX1jcdi7JDToeIbvToC8@mail.gmail.com>
References: <AANLkTilDmFF4IN1Glo_Bv_-eBX1jcdi7JDToeIbvToC8@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xianghua Xiao writes:
 > It seems mmap() can not do random allocation for malloc()/heap on
 > Linux, anyone used pax's 'mmap randonness' option for that? what's the
 > price for that?
 > 
 > I want to port openbsd's malloc() to linux to avoid heap
 > crashes(overrun/underrun), openbsd's malloc() can do random allocation
 > for security reasons, meanwhile it helps to avoid some
 > overrun/underrun crashes with no extra cost, the latter is what I'm
 > looking for.

You can implement this in user-space with existing kernel features.
1: place guard pages around mmap():ed data
2: parse /proc/self/maps and mmap(MAP_FIXED)
3: use a "safe" compiler or a dynamic binary instrumenter
4: use x86 segments (ugh!)
5: use a safe programming language
...
