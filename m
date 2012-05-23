Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab2EWPoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:44:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857Ab2EWPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:44:07 -0400
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <4FBD0236.7040508@linux.vnet.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
	 <1337677268.9698.6.camel@twins>  <4FBCCAE2.7080706@linux.vnet.ibm.com>
	 <1337773798.27020.175.camel@laptop>  <4FBD0236.7040508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 17:43:54 +0200
Message-ID: <1337787834.9783.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 17:28 +0200, Christian Ehrhardt wrote:
> We don't have any code for CONFIG_PARAVIRT and its childs yet, so I need 
> to look further into it. 

Yeah, screw CONFIG_PARAVIRT :-) Its just that the code that deals with
high res steal time is only used by them. So ideally you'd extract the
relevant bits from under CONFIG_PARAVIRT and use them.

So its that one block in update_rq_clock_task() (or both if you also
have high res irq accounting) and then you need to provide
paravirt_steal_clock(int cpu) which returns the steal time of that cpu
in nano-seconds granularity. Which I'm assuming s390 has available
someplace.

+- some renames to remove the paravirt_ part of names.

