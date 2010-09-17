Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0IQBfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:35:21 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:40812 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752085Ab0IQBfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:35:20 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 5mgd2mcVM1m54uMWPw3zpfHVmnTe1GvYi_sHpA86iI3CLG3
 KHjfL891C4THN0F.njpCMGVJaBIwobHX0xctBd.dK6i2swc_tgh4Zcbv9eY0
 g6tt2E.zLcG4xs9lwtVn1VMNewl7k_E6U3442ns4hTkwJBQdkFx9IbbrZJCJ
 G_FPOy75LycTclWJBp8VqYT31BekibQJAst5twgTXkPqXhjmcGnyNr.929k3
 mlP8d6_nYSEJozo_t6nuFIKOVO0YUeqCpYFi.yXUOPlj9n3hZ0EfnGPvOO7E
 k5xbQOIbwQLkgrEoa.XrEXO.GDYajbHotuvUCXvwXIfCd9KExzio-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1284686949.7280.99.camel@schen9-DESK>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <1284686949.7280.99.camel@schen9-DESK>
Content-Type: text/plain
Date: Thu, 16 Sep 2010 18:31:10 -0700
Message-Id: <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:29 -0700, Tim Chen wrote:
> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings all,
> > 
> > This series contains the first round of a whole-sale conversion for droping
> > struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> > scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> > that is protected by host_lock is scsi_cmd_get_serial)_.
> > 
> 
> Maybe we can change the host->cmd_serial_number to atomic and totally
> avoid the need to take host_lock.

Hmmmm good point, then we would also need an atomic_t for signaling
(shost_state == SHOST_DEL) in scsi_dispatch_cmd() to be able to
completly drop host_lock usage within scsi_dispatch_cmd().

I can take a look at doing this specific part, if you would be willing
to have a look at the host->cmd_serial_number conversion piece.  ;)

Thanks Tim!

--nab


