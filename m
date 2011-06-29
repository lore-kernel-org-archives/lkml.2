Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab1F2UM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:12:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:1979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab1F2UMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:12:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,445,1304319600"; 
   d="scan'208";a="19829011"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory Power Management
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	<20110629130038.GA7909@in.ibm.com> <1309367184.11430.594.camel@nimitz>
	<20110629174220.GA9152@in.ibm.com> <1309370342.11430.604.camel@nimitz>
Date: Wed, 29 Jun 2011 13:11:00 -0700
In-Reply-To: <1309370342.11430.604.camel@nimitz> (Dave Hansen's message of
	"Wed, 29 Jun 2011 10:59:02 -0700")
Message-ID: <m2y60k1jqj.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:
>
> It's also going to be a pain to track kernel references.  On x86, our

Even if you tracked them what would you do with them?

It's quite hard to stop using arbitary kernel memory (see all the dancing
memory-failure does) 

You need to track the direct accesses to user data which happens
to be accessed through the direct mapping.

Also it will be always unreliable because this all won't track DMA.
For that you would also need to track in the dma_* infrastructure,
which will likely get seriously expensive.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
