Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1FCP25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:28:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1FCP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:28:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Fri, 3 Jun 2011 17:28:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Timur Tabi <timur@freescale.com>, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, akpm@kernel.org,
        linux-console@vger.kernel.org, greg@kroah.com,
        linuxppc-dev@lists.ozlabs.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106012340.14237.arnd@arndb.de> <20110601172412.761ff799@schlenkerla.am.freescale.net>
In-Reply-To: <20110601172412.761ff799@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031728.43707.arnd@arndb.de>
X-Provags-ID: V02:K0:EAZEjrN63kAt1mjXQv3bndxVbBffyzzhKTKElJ4OylO
 Op2U/pT6ISN85GbbL59Q1HOLZWdqmCsqJB3ardF8eW8bSMI0Kp
 xYtGm/aaVPRaRhfGlK/jK5znwKAdW1KkL+f7xosg9H8bDp+X+x
 IyMhGGW8P/TxvHSc38fqs+lcX0Nzx+CAbuVlEMZViWzOSHABa8
 R/5FdKkfdiuadzT3oSVRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 June 2011, Scott Wood wrote:
> I wanted to have the hypervisor take an update dtb (we already have special
> meta-properties for things like deletion as part of the hv config
> mechanism).  But others on the project wanted to keep it simple, and so
> get/set property it was. :-/
> 
> It's unlikely to change at this point without a real need.
> 
> As for a filesystem interface, it's not a good match either. 
> You can't iterate over anything to read out the full tree from the hv.

kexec iterates over /proc/device-tree to create a dts blob.

> You can't delete anything. 

rm, rmdir

> You can't create empty nodes.

mkdir

> The hv interface was meant to enable some specific management actions,
> rather than to provide general device tree access.  This driver is a thin
> wrapper around the management hcalls.

A file system would be a slightly more abstract interface to do the
same thing, I gues.

> There would still be other ioctls needed for starting/stopping the
> partition, etc.

Right, although you could model them as a file interface as well.
KVMfs is one example doing that.

	Arnd
