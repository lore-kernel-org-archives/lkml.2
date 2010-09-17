Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0IQB2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:28:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:22301 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab0IQB2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,379,1280732400"; 
   d="scan'208";a="325564476"
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
 caller
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
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
In-Reply-To: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 18:29:09 -0700
Message-ID: <1284686949.7280.99.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
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

Maybe we can change the host->cmd_serial_number to atomic and totally
avoid the need to take host_lock.

Tim

