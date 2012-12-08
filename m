Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2LHA6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:58:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58669 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2LHA6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:58:01 -0500
Date: Fri, 7 Dec 2012 16:57:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@air.linux-foundation.org
To: Milan Broz <mbroz@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Read O_DIRECT regression in 3.7-rc8 (bisected)
In-Reply-To: <alpine.LFD.2.02.1212071640510.24455@air.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1212071656190.4272@air.linux-foundation.org>
References: <50C2820B.5060005@redhat.com> <alpine.LFD.2.02.1212071640510.24455@air.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Dec 2012, Linus Torvalds wrote:
> 
> This (TOTALLY UNTESTED) patch adds it the same iov_shorten() logic that 
> the write side has. It does it differently (in fs/block_dev.c rather than 
> in mm/filemap.c), but I actually suspect this is a nicer way to do it, and 
> maybe we should do the write side truncation this way too.

Ok, rebooted and tested with your test-case, and it seems to work fine. 
But I presume that you actually found the problem some other way, so you'd 
want to verify that it fixes whatever original bigger issue you hit.

Thanks,
            Linus
