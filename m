Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0JURR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab0JURRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:17:55 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix array overflow in CFQ
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
	<4CBD6C84.3020309@kernel.dk> <20101019114933.GA857@redhat.com>
	<20101019123320.GB857@redhat.com> <4CBD9BCA.2060200@linux.intel.com>
	<20101019150516.GE857@redhat.com>
	<x49fwvz1o8c.fsf@segfault.boston.devel.redhat.com>
	<20101021171600.GA6277@gargoyle.fritz.box>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 21 Oct 2010 13:15:03 -0400
In-Reply-To: <20101021171600.GA6277@gargoyle.fritz.box> (Andi Kleen's message
	of "Thu, 21 Oct 2010 19:16:00 +0200")
Message-ID: <x49bp6n1n8o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

>> > Agreed.
>> >
>> > Jens, do you want me to regenerate your patch so that we increase the
>> > size of ->busy_queues_avg[CFQ_PRIO_NR] but not ->service_trees[][].
>> 
>> Just be sure to put a huge comment in there so you don't confuse the
>> poor masses trying to make sense of the code.
>
> Right now the code is confusing, with a correctly sized array it would
> be completely straight forward.

That's not entirely true.  You want a comment to state that the array
size is adjusted to ensure no accidental overflows, but in reality, that
third bucket is never used.

Cheers,
Jeff
