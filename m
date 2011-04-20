Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1DTHI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:08:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52146 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1DTHI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:08:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH followup] mm: get rid of CONFIG_STACK_GROWSUP || CONFIG_IA64
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110420065943.GA18799@tiehlicka.suse.cz>
References: <20110420093326.45EF.A69D9226@jp.fujitsu.com> <20110420065943.GA18799@tiehlicka.suse.cz>
Message-Id: <20110420160946.4629.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 16:08:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Kosaki,
> 
> On Wed 20-04-11 09:33:26, KOSAKI Motohiro wrote:
> > > While I am in the cleanup mode. We should use VM_GROWSUP rather than
> > > tricky CONFIG_STACK_GROWSUP||CONFIG_IA64.
> > > 
> > > What do you think?
> > 
> > Now, VM_GROWSUP share the same value with VM_NOHUGEPAGE.
> > (this trick use the fact that thp don't support any stack growup architecture)
> 
> I am not sure I understand you. AFAICS, VM_GROWSUP is defined to non 0
> only if CONFIG_STACK_GROWSUP||CONFIG_IA64 (include/linux/mm.h).
> And we use it to determine whether expand_stack_growsup[*] should be
> defined (in include/linux/mm.h).
> 
> The patch basically unifies the way how we export expand_stack_growsup
> function and how define it (in mm/mmap.c).
> 
> So either we should use CONFIG_STACK_GROWSUP||CONFIG_IA64 at both places
> or we should use VM_GROWSUP trick. I am for the later one.
> 
> Am I missing something?
> 
> --- 
> [*] the previous patch renamed expand_growsup to expand_stack_growsup.

Right you are. sorry.



