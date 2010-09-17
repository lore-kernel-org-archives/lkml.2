Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0IQOWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:22:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:12172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0IQOWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,383,1280732400"; 
   d="scan'208";a="838583999"
Message-ID: <4C9379AA.4000103@linux.intel.com>
Date: Fri, 17 Sep 2010 16:22:34 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>	 <1284691571.26423.50.camel@mulgrave.site>	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com> <1284725592.26423.60.camel@mulgrave.site>
In-Reply-To: <1284725592.26423.60.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't disagree with the idea of removing it, especially as it has so
> few users, but replacing the host lock with an atomic here would still
> vastly reduce the contention, which is the initial complaint.  The

Actually the complaint is the overhead of the spin lock. This can be 
either caused
by contention or by cache line bounce time.

> contention occurs because the host lock is so widely used for other
> things.  The way to reduce that contention is firstly to reduce the
> length of code covered by the lock and also reduce the actual number of
> places where the lock is taken.  Compared with host lock's current vast
> footprint, and atomic here is tiny.

That assumes that it's contention that is the problem and not simply 
bounce time.

-Andi

