Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2DNBXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:23:16 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:37231 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2DNBXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:23:14 -0400
Subject: Re: [PATCH v3 00/11] firewire-sbp-target: FireWire SBP-2 SCSI
 target
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de, Christoph Hellwig <hch@lst.de>
In-Reply-To: <4F882745.4080301@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
	 <1334154043-69076-1-git-send-email-bootc@bootc.net>
	 <1334286222.3137.4877.camel@haakon2.linux-iscsi.org>
	 <4F882745.4080301@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Apr 2012 18:23:03 -0700
Message-ID: <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 14:16 +0100, Chris Boot wrote:
> On 13/04/2012 04:03, Nicholas A. Bellinger wrote:

<SNIP>

> > So I've merged a squashed version this series from:
> >
> >    https://github.com/bootc/Linux-SBP-2-Target.git patch-v3
> >
> > into lio-core/master, and have now pushed to k.o upstream
> 
> Thanks!
> 
> > This looks to me like a reasonable candidate for a v3.5 mainline merge,
> > so we need to go ahead and get this into target-pending..  Also, thanks
> > for getting Stefan's ACK's here on the drivers/firmware/ specific
> > changes..
> >
> > So for new fabric drivers (as discused with Sebastian and usb-gadget
> > recently) that the target team has been enforcing that new fabric
> > modules convert to use a single source / header file for readability and
> > maintainability purposes.
> >
> > It would be great if you can publish one more branch (no need to re-post
> > the full diff) that takes your patch-v3 down to a single .c/.h file.
> > Otherwise, I'm fine to take the 15 minutes to do this conversion ahead
> > of dropping into target-pending for the sunday night linux-next build.
> 
> I'll get onto it over the weekend, I hope. I assume in this case I just 
> stick it all in drivers/target/ instead of having a sbp/ directory 
> underneath that?
> 

I was eager to see this change, so I decided to go ahead and do the
mechanical conversion myself in the following branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core.git sbp-merge

As mentioned, it converts drivers/target/sbp/ to use a single sbp_target.[c,h]
source/header file following mainline convention for new target fabric
drivers.  Also make as many functions as possible statically defined and
add inline prototypes where necessary.

This patch also renames the sbp-target config entry from:

    FIREWIRE_SBP_TARGET -> SBP_TARGET

and also renames the final generated module name from:

    fireware-sbp-target.ko -> sbp_target.ko

Here is what the diffstat ends up looking like:

 drivers/target/Makefile                   |    2 +-
 drivers/target/sbp/Kconfig                |    6 +-
 drivers/target/sbp/Makefile               |   12 +-
 drivers/target/sbp/sbp_base.h             |  211 ---
 drivers/target/sbp/sbp_configfs.c         |  737 --------
 drivers/target/sbp/sbp_fabric.c           |  314 ----
 drivers/target/sbp/sbp_fabric.h           |   40 -
 drivers/target/sbp/sbp_login.c            |  672 --------
 drivers/target/sbp/sbp_login.h            |   17 -
 drivers/target/sbp/sbp_management_agent.c |  255 ---
 drivers/target/sbp/sbp_management_agent.h |   34 -
 drivers/target/sbp/sbp_scsi_cmnd.c        |  430 -----
 drivers/target/sbp/sbp_scsi_cmnd.h        |   12 -
 drivers/target/sbp/sbp_target.c           | 2621 +++++++++++++++++++++++++++++
 drivers/target/sbp/sbp_target.h           |  254 +++
 drivers/target/sbp/sbp_target_agent.c     |  395 -----
 drivers/target/sbp/sbp_target_agent.h     |   40 -
 17 files changed, 2879 insertions(+), 3173 deletions(-)
 delete mode 100644 drivers/target/sbp/sbp_base.h
 delete mode 100644 drivers/target/sbp/sbp_configfs.c
 delete mode 100644 drivers/target/sbp/sbp_fabric.c
 delete mode 100644 drivers/target/sbp/sbp_fabric.h
 delete mode 100644 drivers/target/sbp/sbp_login.c
 delete mode 100644 drivers/target/sbp/sbp_login.h
 delete mode 100644 drivers/target/sbp/sbp_management_agent.c
 delete mode 100644 drivers/target/sbp/sbp_management_agent.h
 delete mode 100644 drivers/target/sbp/sbp_scsi_cmnd.c
 delete mode 100644 drivers/target/sbp/sbp_scsi_cmnd.h
 create mode 100644 drivers/target/sbp/sbp_target.c
 create mode 100644 drivers/target/sbp/sbp_target.h
 delete mode 100644 drivers/target/sbp/sbp_target_agent.c
 delete mode 100644 drivers/target/sbp/sbp_target_agent.h


Please have a look at this branch over the next days, and if you're OK
with the re-org changes I'll go ahead and merge this into
lio-core/master, and drop into target-pending for sunday night's build.

Thanks Chris!

--nab

