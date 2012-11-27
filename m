Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2K0WAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:00:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34525 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2K0WAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:00:20 -0500
Date: Tue, 27 Nov 2012 14:00:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: memory allocation: smap large "Size", but unused
In-Reply-To: <k930p2$8br$1@ger.gmane.org>
Message-ID: <alpine.DEB.2.00.1211271359260.23576@chino.kir.corp.google.com>
References: <k930p2$8br$1@ger.gmane.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012, Bernd Schubert wrote:

> I'm just investigating why a user space program has a rather large VmSize, but
> small VmRSS size. Looking into /proc/$pid/smaps I notice several areas with an
> size of about 64MB, but otherwise that area is unused. So far I did not find a
> way how to reproduce that with malloc() calls.
> 
> 7ffd34021000-7ffd38000000 ---p 00000000 00:00 0
> Size:              65404 kB
> Rss:                   0 kB

What happens if you do

	sbrk(65404 << 10);
	sleep(1000);

and check /proc/pid/smaps?  Ah, a memory range need not have any pages in 
memory.
