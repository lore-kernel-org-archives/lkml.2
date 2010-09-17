Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab0IQTAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 15:00:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:17859 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0IQTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 15:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,384,1280732400"; 
   d="scan'208";a="838660345"
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
 caller
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
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
In-Reply-To: <4C93B2BC.8000404@garzik.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <1284686949.7280.99.camel@schen9-DESK>
	 <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
	 <4C93B2BC.8000404@garzik.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 12:01:52 -0700
Message-ID: <1284750112.7280.160.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 14:26 -0400, Jeff Garzik wrote:

> 
> But that raises the familiar tale of:  using multiple atomics (w/ their 
> locked instructions) may cost more than a spinlock.
> 

As brought up by James earlier, the scsi_host lock was used in so many
places that getting rid of it here to reduce contention for it will be a
net win, even with the cost of the atomics.  And for most LLDs that
don't need the serial number, we can just initialize it to zero for
those and have no need to increment it (thus also avoiding the atomics'
cost).

Tim

