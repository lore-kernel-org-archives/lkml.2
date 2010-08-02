Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0HBQyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:54:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60590 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab0HBQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:54:12 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (scsi-post-merge tree related)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20100803024701.b3dff69a.sfr@canb.auug.org.au>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au>
	 <20100803024701.b3dff69a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 11:54:08 -0500
Message-ID: <1280768048.2843.242.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

missing linux-scsi added to cc list.

On Tue, 2010-08-03 at 02:47 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 3 Aug 2010 02:44:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (powerpc allmodconfig)
> > failed like this:
> > 
> > ERROR: ".iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> > ERROR: ".iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> > ERROR: ".iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> > ERROR: ".iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> > ERROR: ".iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
> > 
> > Caused by commit a33e2a708b2e83ee6111e45c8d3d49a112c3c887 ("[SCSI]
> > be2iscsi: Add support for iscsi boot").  For some reason, commit
> > ed94aa526655d915076dcdbbf4fc962b2a67fcb5 ("[SCSI] be2iscsi: select
> > ISCSI_BOOT_SYSFS") was not sufficient to make sure that
> > CONFIG_ISCSI_BOOT_SYSFS is defined for this build.
> 
> It turns out that drivers/firmware/Kconfig is only included on x86, ia64
> and blackfin.

OK, we need to turn this around then and make be2iscsi only use iscsi
boot if it's enabled ... that's going to be some fun #ifdefing in the
driver.

James


