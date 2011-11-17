Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1KQUyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:54:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1KQUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:54:16 -0500
Date: Thu, 17 Nov 2011 12:54:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Introduce CAP_CHECKPOINT capability and filter map_files/
 access
Message-Id: <20111117125414.0b134897.akpm@linux-foundation.org>
In-Reply-To: <20111117154105.GA4522@sergelap>
References: <20111117100439.GK20508@moon>
	<20111117154105.GA4522@sergelap>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 09:41:05 -0600
"Serge E. Hallyn" <serge.hallyn@canonical.com> wrote:

> >  - (not yet merged) clone-with-specified-pid, might be changed to last_pid+clone setup
> >  - (not yet published/stabilized) prctls calls to tune up vDSO and elements
> >    of mm_struct such as mm->start_code, mm->end_code, mm->start_data and etc
> > 
> > I would like to gather people opinions on such approach as a general.
> > _ANY_ comments are highly appreciated. Would it worth it or not (since
> > CAPs space is pretty limited one).
> 
> It's hard to have a specific dialogue without the full c/r patchset and
> idea of the architecture of the exploiters (ie c/r and maybe
> debuggers)
> 
> Sorry, the security implications of the in-kernel c/r syscalls were
> pretty simple and clear to me, but those of the new approach are not.

yup.

>From a development-order perspective perhaps it is better to get
everything working and stabilized for root first.  Then as a separate
activity start working on making it available to less-privileged users.

We would need to be confident that such a second development effort
doesn't cause back-compatibility issues (ie: interface changes) for
existing root users.



Is it possible that once everything is working for root, we realise
that we can get it all working for non-root users via suitable setuid
userspace tools?
