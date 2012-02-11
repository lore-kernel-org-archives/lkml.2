Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2BKDJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 22:09:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2BKDJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 22:09:31 -0500
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Peter Zijlstra <peterz@infradead.org>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	 <1328901567.25989.51.camel@laptop>
	 <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Feb 2012 04:09:21 +0100
Message-ID: <1328929761.2476.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 18:11 -0800, Venki Pallipadi wrote:

> OK. Moving most of this into arch code will be cleaner. But, Yong
> mentioned in this thread that he was looking to do something similar
> on MIPS. So, we may end up with some code duplication though..

If there's significant duplication you can always move a few helpers
into lib/, but I think we shouldn't let this get outside of the PIC and
idle code (both clearly arch specific), all we're doing is optimizing
the IPI delivery, conceptually we're still sending one.


