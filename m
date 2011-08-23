Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1HWORk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:17:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:52843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1HWORg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:17:36 -0400
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Date: Tue, 23 Aug 2011 16:17:23 +0200
In-Reply-To: <20110823141452.GL2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
	 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
	 <1314022580.24275.33.camel@twins> <20110823141452.GL2067@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314109043.8002.58.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 10:14 -0400, Don Zickus wrote:

> Maybe I don't understand kfree_rcu, but what advantage do I have by
> placing rcu_head into nmiaction that never gets used except on unregister
> (which rarely happens to begin with)?

you don't have to wait for sync_rcu(), but you're right, this is an
absolute slow patch and we don't care.
