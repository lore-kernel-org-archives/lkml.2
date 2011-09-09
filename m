Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab1IIRWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459Ab1IIRWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:22:00 -0400
Date: Fri, 9 Sep 2011 19:18:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
	'data'
Message-ID: <20110909171832.GA26810@redhat.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109091415.33503.pedro@codesourcery.com> <1315587343.5036.6.camel@dhcp-25-63.brq.redhat.com> <201109091809.57272.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109091809.57272.pedro@codesourcery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Pedro Alves wrote:
>
> WTH?  I'm talking about _not forcing the tracee to stop_.

The patch is trivial.

And personally I agree, this looks like a cleanup to me.

Oleg.

--- x/include/linux/ptrace.h
+++ x/include/linux/ptrace.h
@@ -199,7 +199,8 @@ static inline void ptrace_event(int even
 		ptrace_notify((event << 8) | SIGTRAP);
 	} else if (event == PTRACE_EVENT_EXEC && unlikely(current->ptrace)) {
 		/* legacy EXEC report via SIGTRAP */
-		send_sig(SIGTRAP, current, 0);
+		if (!(current->ptrace & PT_SEIZED))
+			send_sig(SIGTRAP, current, 0);
 	}
 }
 

