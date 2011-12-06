Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1LFTFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:05:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab1LFTFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:05:34 -0500
Date: Tue, 6 Dec 2011 13:10:01 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 0/3] Use jump_label for sched_feat()
Message-ID: <20111206181000.GE2449@redhat.com>
References: <20111206171534.429636558@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206171534.429636558@chello.nl>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 06:15:34PM +0100, Peter Zijlstra wrote:
> These patches implement sched_feat() using jump_labels. The first is a section
> mismatch fix. The second patch provides a little infrastructure and the third
> patch applies it to make sched_feat() use static_branch().
> 
> It uses static_branch() coupled with unlikely/likely in order to control the
> branch block position. I haven't checked if it works, but it likely doesn't,
> although it should.
> 
> 

It doesn't. I played around with unlikely/likely a bit, and it
didn't seem to make a difference. That said, jump_labels could still be
an improvement here - it be good if we had some numbers, I guess.

Thanks,

-Jason
