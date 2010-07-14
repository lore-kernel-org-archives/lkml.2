Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0GNAkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:40:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41194 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0GNAka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:40:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Jul 2010 09:35:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
Message-Id: <20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3C8B9E.7000208@austin.ibm.com>
References: <4C3B3446.5090302@austin.ibm.com>
	<4C3B3895.3040209@austin.ibm.com>
	<20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C3C8B9E.7000208@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 10:51:58 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> > 
> > And for what purpose this interface is ? Does this split memory block into 2 pieces
> > of the same size ?? sounds __very__ strange interface to me.
> 
> Yes, this splits the memory_block into two blocks of the same size.  This was
> suggested as something we may want to do.  From ppc perspective I am not sure we
> would use this.
> 
> The split functionality is not required.  The main goal of the patch set is to
> reduce the number of memory sysfs directories created.  From a ppc perspective
> the split functionality is not really needed.
> 

Okay, this is an offer from me.

  1. I think you can add an boot option as "don't create memory sysfs".
     please do.

  2. I'd like to write a configfs module for handling memory hotplug even when
     sysfs directroy is not created.
     Because configfs support rmdir/mkdir, the user (ppc's daemon?) has to do
     
     When offlining section X.
     # insmod configfs_memory.ko
     # mount -t configfs none /configfs
     # mkdir /configfs/memoryX
     # echo offline > /configfs/memoryX/state
     # rmdir /configfs/memoryX

  And making this operation as the default bahavior for all arch's memory hotplug may
  be better...

Dave, how do you think ? Because ppc guys uses "probe" interface already,
this can be handled... no ?

One problem is that I don't have enough knowledge about configfs..it seems complex.

Thanks,
-Kame
  

