Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0H3B0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:26:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0H3B0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:26:52 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@parisplace.org>, netfilter@vger.kernel.org
Subject: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
Date: Mon, 30 Aug 2010 03:26:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
References: <1282682582-15980-1-git-send-email-eparis@redhat.com> <AANLkTimbQivEd7z1+sdLgChieGrY3c9iQWXVKgcYRAY=@mail.gmail.com>
In-Reply-To: <AANLkTimbQivEd7z1+sdLgChieGrY3c9iQWXVKgcYRAY=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008300326.30233.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 August 2010 01:51:53 Eric Paris wrote:
> I liked this version until I realized that userspace doesn't have
> aligned_u64 as a valid type.

This looks like an error in include/linux/types.h.  The aligned types should 
probably not be defined inside #ifdef __KERNEL__.

The following other headers expose aligned 64-bit types to user space as well; 
copying the netfilter list:

	include/linux/if_ppp.h
	include/linux/netfilter/nfnetlink_queue.h
	include/linux/netfilter/nfnetlink_log.h
	include/linux/netfilter/xt_quota.h
	include/linux/netfilter/xt_connbytes.h

Otherwise, the definition of those types is really simple, and this would do 
in include/linux/fanotify.h until include/linux/types.h is fixed:

	#ifndef aligned_u64
	# define aligned_u64 __u64 __attribute__((aligned(8)))
	#endif

Thanks,
Andreas
