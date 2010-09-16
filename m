Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0IPXFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:05:54 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:29376 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753964Ab0IPXFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:05:52 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: HLmC4F8VM1mriiUYg.dazgT6EU4eqX_tkEDuKzqxECrmzHz
 B.p6BuEdCbI905LhypC0_5CD.tGLalNvnrv8LpWpkgACbJAVrLbOahooQz41
 m1gzXpuuaCLOv6WsaKmWwAjXVVU8EWNp.4NIxk6XtjxsRQiHl_u8TDehIG4S
 ztsuzceBk27DxXK9T5PfyAuFeuJ0.hWMxrk5XuPs5nACClGyaxjgSif0jOGD
 1_QcrqfTVtM3cbk3Beuy7C9J2jGj2DK_KFptGUSwEXiCP3Rj7v6lKrmGU6tK
 vfiYtOq3B74wUoIkW31_PwJef2wAx_FDrU3bLgwSRiO2kLMMaFBuxbn5n
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain
Date: Thu, 16 Sep 2010 16:01:43 -0700
Message-Id: <1284678103.13344.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This series contains the first round of a whole-sale conversion for droping
> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> that is protected by host_lock is scsi_cmd_get_serial)_.
> 
> The patches #2 -> #8 converts libiscsi, libsas, lpfc, qla4xxx, qla2xxx,
> TCM_Loop, and libfc code to drop their own SHT->queuecommand() internal
> host_lock unlock() + lock() optimization that certain high performance libs
> and LLDs have adopted over the years.  The changes involved here are really
> quite straight forward, but please note that none of this code has been tested
> with actual hardware yet, and is intended for generating comments for the relivent
> SCSI LLD driver maintainers and other interested folks.
> 
> There are probably still be more LLDs which use this optimization, so please
> let me know if there is another piece of SHT->queuecommand() caller code that
> does this legacy optimization and needs to be updated.  I will be sure to
> CC the right driver maintainers and CC linux-scsi as I come across any more
> conversions.

Hi Guys,

drivers/scsi/fnic needs the conversion as well..  Here is that patch;

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=3c886b2ab6faccbe2803094deb7a9647199e5118

Thanks!

--nab

