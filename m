Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1GYPBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:01:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:49799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1GYPBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:01:03 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1311605881.24752.2.camel@twins>
References: <20110721164325.231521704@google.com>
	 <1311605881.24752.2.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Jul 2011 17:00:41 +0200
Message-ID: <1311606041.24752.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 16:58 +0200, Peter Zijlstra wrote:
> +               rcu_read_lock();
> +               ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
> +               rcu_read_unlock(); 

rcu over a mutex doesn't really work in mainline, bah.. 
