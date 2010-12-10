Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0LJIJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:09:08 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37611 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0LJIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:09:06 -0500
From: Miles Bader <miles@gnu.org>
To: Joe Perches <joe@perches.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from mapping_unevictable()
References: <20101207021328.569328536@goodmis.org>
	<1291688533.16223.119.camel@gandalf.stny.rr.com>
	<20101210160115.C7C4.A69D9226@jp.fujitsu.com>
	<1291964792.24978.3.camel@Joe-Laptop>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Fri, 10 Dec 2010 17:08:05 +0900
In-Reply-To: <1291964792.24978.3.camel@Joe-Laptop> (Joe Perches's message of
	"Thu, 09 Dec 2010 23:06:32 -0800")
Message-ID: <buok4jikq3e.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> It'd be better to use
>
> 	if (!mapping)
> 		return 0;
> 	return test_bit(AS_UNEVICTABLE, &mapping->flags);
>
> to avoid the unnecessary !!

How about 

 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);

instead...?

-miles

-- 
Yossarian was moved very deeply by the absolute simplicity of
this clause of Catch-22 and let out a respectful whistle.
"That's some catch, that Catch-22," he observed.
"It's the best there is," Doc Daneeka agreed.
