Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2ISPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab2ISPQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:16:53 -0400
Date: Wed, 19 Sep 2012 11:16:51 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] block: make struct block_device cacheline_aligned
In-Reply-To: <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.1209191116240.30172@file.rdu.redhat.com>
References: <x49lig686kv.fsf@segfault.boston.devel.redhat.com>
 <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2012, Jeff Moyer wrote:

> Jeff Moyer <jmoyer@redhat.com> writes:
> 
> > Hi,
> >
> > When testing against a pcie ssd or a ramdisk, making the block device
> > structure cacheline_aligned provided a significant increase in
> > performance:
> 
> Self-NACK on this one.  This results in a ton of warnings:
> 
> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> apply to types
> In file included from include/linux/debugfs.h:18,
>                  from kernel/trace/trace_probe.h:28,
>                  from kernel/trace/trace_kprobe.c:23:
> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> apply to types
> 
> And that leaves me with the task of figuring out if/why this actually
> helps.
> 
> Cheers,
> Jeff

Hi

Use ____cacheline_aligned instead of __cacheline_aligned

Mikulas
