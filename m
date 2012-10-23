Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2JWJEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:04:45 -0400
Received: from mout.web.de ([212.227.15.4]:51755 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab2JWJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:04:43 -0400
Date: Tue, 23 Oct 2012 11:04:34 +0200
From: Julian Wollrath <jwollrath@web.de>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Julian Wollrath <jwollrath@web.de>,
        Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Subject: Re: Major performance regressions in 3.7rc1/2
Message-ID: <20121023110434.021d100b@ilfaris>
In-Reply-To: <alpine.LNX.2.00.1210222059120.1136@eggly.anvils>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
	<20121022173315.7b0da762@ilfaris>
	<20121022214502.0fde3adc@ilfaris>
	<20121022170452.cc8cc629.akpm@linux-foundation.org>
	<alpine.LNX.2.00.1210222059120.1136@eggly.anvils>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Xm+VwAsD63x2X3MaAwVlpEXpT44LxewouhLQ0VuTvfm
 kmh5O1QnUVUALeOKL6PkiVDF2gaP9gYS5/AWnZqqMmr/NsBmU0
 MUL0TIsy4wvA8NiqsmyUKC1MwgiXJn6mH/XX0auhSIPwakSB1r
 j8nFHN0BiBJxa6gB19v8w7iMWzcTvLU7cWYzWuYiBL8co3ToKV
 kM/Hrf3Mduk4cyNlcgD0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thanks.  Let's add some cc's.  Can you please describe your workload
> > and some estimate of the slowdown?
I am using fluxbox with Iceweasel, Claws-Mail and urxvt on different
workspaces on a Thinkpad X121e with an AMD E-450 APU. Loading some big
pages in Iceweasel leades to a very sluggish rendering of the urxvt
window when changing workspaces, the cursor movement falters. The
falter in the cursor movement is from random length but I would
estimate, that it is mostly under one second. But sometimes the time
between the each falter is very short which results in a more or less
unusable system.

> I'm currently assuming that my clear_page_mlock() commit is innocent
> of this: it went in just two before David's numa reclaim commit, and
> I don't see how mine could have any such marked effect: I'm thinking
> it was just a bisection hiccup that implicated it.
Just tested v3.7-rc2 with your clear_page_mlock() and without the numa
reclaim commit and everything worked fine. So you are right, most
probable it was a bisection hiccup, the reclaim commit is the real bad
commit. Nevertheless I am wondering why everything worked fine until
39b5f29a (mm: remove vma arg from page_evictable) and then started to
behave badly with your clear_page_mlock() commit but 3.7-rc2 works fine
with only the numa reclaim commit revoked.


With best regards,
Julian Wollrath
