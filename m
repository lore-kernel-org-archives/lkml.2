Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1KQVcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:32:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64810 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1KQVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:32:03 -0500
Date: Fri, 18 Nov 2011 01:31:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Introduce CAP_CHECKPOINT capability and filter map_files/
 access
Message-ID: <20111117213157.GS20508@moon>
References: <20111117100439.GK20508@moon>
 <20111117154105.GA4522@sergelap>
 <20111117125414.0b134897.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117125414.0b134897.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 12:54:14PM -0800, Andrew Morton wrote:
...
> > 
> > It's hard to have a specific dialogue without the full c/r patchset and
> > idea of the architecture of the exploiters (ie c/r and maybe
> > debuggers)
> > 
> > Sorry, the security implications of the in-kernel c/r syscalls were
> > pretty simple and clear to me, but those of the new approach are not.
> 
> yup.
> 
> From a development-order perspective perhaps it is better to get
> everything working and stabilized for root first.  Then as a separate
> activity start working on making it available to less-privileged users.
> 
> We would need to be confident that such a second development effort
> doesn't cause back-compatibility issues (ie: interface changes) for
> existing root users.
> 
> Is it possible that once everything is working for root, we realise
> that we can get it all working for non-root users via suitable setuid
> userspace tools?

Once it operates well under root (actually I'm testing it under kvm with
root account) I believe tuning code up for non-root users should be possible
too. At moment I need cap-sys-admin only because of map_files/ but technically
I barely need ptrace over dumping task(s) and access to map_files.

	Cyrill
