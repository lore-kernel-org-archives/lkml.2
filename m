Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1IGQdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:38274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1IGQdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:14 -0400
Subject: Re: [PATCH -mm 4/4] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Wed, 07 Sep 2011 09:52:22 +0200
In-Reply-To: <4E66C0EA.6010302@intel.com>
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com>
	 <1315290307-25145-4-git-send-email-ying.huang@intel.com>
	 <20110906105750.GD21602@Krystal> <4E66C0EA.6010302@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315381942.11101.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 08:55 +0800, Huang Ying wrote:
> 2) make llist_add return whether list is empty before adding

That seems the sanest approach, it needs to set entry->next anyway, so
it might as well return the last known state.
