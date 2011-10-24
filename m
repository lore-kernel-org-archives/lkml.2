Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab1JXQ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:28:47 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:33472 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab1JXQ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:28:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Eric Paris <eparis@parisplace.org>
X-Fcc: ~/Mail/lkml
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
        selinux@tycho.nsa.gov, John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE
 mappings
In-Reply-To: Eric Paris's message of  Monday, 24 October 2011 11:07:48 -0400 <1319468868.3280.9.camel@localhost>
References: <20111021213916.914462C0A5@topped-with-meat.com>
	<CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com>
	<20111022172450.0BCCE2C0A9@topped-with-meat.com>
	<CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
	<20111023185243.EFE2F2C08F@topped-with-meat.com>
	<1319468868.3280.9.camel@localhost>
Emacs: the road to Hell is paved with extensibility.
Message-Id: <20111024162842.CE1942C09C@topped-with-meat.com>
Date: Mon, 24 Oct 2011 09:28:42 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=fe7WOzsF c=1 sm=1 a=27hm96M904wA:10
		a=kj9zAlcOel0A:10 a=YM7LnJMpTPLdd74ak4EA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I feel like, and it's just a very vague feeling, that the PROT bits
> didn't matter to the kernel.  It would still happily execute stuff on
> page 0 even without PROT_EXEC at some point in the past.  I'm probably
> totally off base, and I could test it, but I sort of feel like I
> remember something like that....

Saying that PROT_EXEC might not be enforced is quite a different thing than
saying "PROT bits don't matter".  It's certainly the case that in some past
kernel versions, some hardware (older x86 chips), some configurations (x86
non-PAE), and some modes (READ_IMPLIES_EXEC personality stuff), what you
can read, you can execute.  I sincerely doubt it's ever been the case that
anything mapped as PROT_NONE could be accessed in any manner.


Thanks,
Roland
