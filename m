Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2FLQpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:45:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55402 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2FLQpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:45:38 -0400
Message-ID: <1339519530.31548.88.camel@twins>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hi3766691@gmail.com, Hillf Danton <dhillf@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Zhouping Liu <zliu@redhat.com>
Date: Tue, 12 Jun 2012 18:45:30 +0200
In-Reply-To: <CA+55aFw=akW7B+vRkQRMojnP6_b1YXdKpNEjQ2EyBHcTe2_XLw@mail.gmail.com>
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
	 <1339421268.30462.15.camel@twins> <4FD6BD72.2070808@redhat.com>
	 <1339490988.31548.40.camel@twins>
	 <CA+55aFw=akW7B+vRkQRMojnP6_b1YXdKpNEjQ2EyBHcTe2_XLw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 13:20 +0300, Linus Torvalds wrote:
> you are very fundamentally wrong if you think the distance array has
> to be symmetric. 

I just checked, both QPI and HT are bi-directional links so anything
mid-sized x86 had better be symmetric. Big numa can of course stick in
their own interconnects and might do uni-directional stuff, although I
doubt anybody still does that.

The distance table I have for a 4096 cpu SGI machine is fully symmetric
for instance.

This of course doesn't mean we should make hard assumptions about this
in the scheduler -- and we don't. But in this case it does mean the HP
table is very funny indeed.
