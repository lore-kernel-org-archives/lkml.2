Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0GND1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:27:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54374 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0GND07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:26:59 -0400
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
In-Reply-To: <20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
References: <4C3B3446.5090302@austin.ibm.com>
	 <4C3B3895.3040209@austin.ibm.com>
	 <20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>
	 <4C3C8B9E.7000208@austin.ibm.com>
	 <20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 13 Jul 2010 20:26:56 -0700
Message-ID: <1279078016.10995.58.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 09:35 +0900, KAMEZAWA Hiroyuki wrote:
>   2. I'd like to write a configfs module for handling memory hotplug even when
>      sysfs directroy is not created.
>      Because configfs support rmdir/mkdir, the user (ppc's daemon?) has to do
>      
>      When offlining section X.
>      # insmod configfs_memory.ko
>      # mount -t configfs none /configfs
>      # mkdir /configfs/memoryX
>      # echo offline > /configfs/memoryX/state
>      # rmdir /configfs/memoryX
> 
>   And making this operation as the default bahavior for all arch's memory hotplug may
>   be better...
> 
> Dave, how do you think ? Because ppc guys uses "probe" interface already,
> this can be handled... no ?

I think creating a interface to duplicate the existing sysfs one is a
bad idea.  I also think removing the existing sysfs one isn't feasible
since there are users, and it's truly part of the ABI.  So, I'm not
really a fan on the configfs interface. :(

I really do think the sysfs interface is fixable.  We should at least
give it a good shot before largely duplicating its functionality.

-- Dave

