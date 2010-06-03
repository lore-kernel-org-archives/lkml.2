Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0FCHvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:51:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0FCHvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:51:03 -0400
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, balbir@linux.vnet.ibm.com,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Mel Gorman <mel@csn.ul.ie>, williams@redhat.com
In-Reply-To: <alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com>
References: <20100601173535.GD23428@uudg.org>
	 <alpine.DEB.2.00.1006011347060.13136@chino.kir.corp.google.com>
	 <20100602220429.F51E.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 09:50:49 +0200
Message-ID: <1275551449.27810.34905.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 14:11 -0700, David Rientjes wrote:
> 
> And that can reduce the runtime of the thread holding a writelock on 
> mm->mmap_sem, making the exit actually take longer than without the patch 
> if its priority is significantly higher, especially on smaller machines. 

/me smells an inversion... on -rt we solved those ;-)
