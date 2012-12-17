Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2LQREt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:04:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2LQREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:04:47 -0500
Message-ID: <50CF50AA.7080600@kernel.dk>
Date: Mon, 17 Dec 2012 18:04:42 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jeff Moyer <jmoyer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com> <20121217170016.GA2592@htj.dyndns.org>
In-Reply-To: <20121217170016.GA2592@htj.dyndns.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-17 18:00, Tejun Heo wrote:
> On Mon, Dec 17, 2012 at 11:06:39AM -0500, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> - Export control of bdi flusher thread CPU mask and default to using the
>>>   home node (if known) from Jeff.
>>
>> I certainly wouldn't mind this going in, but I think Tejun NACKed this
>> patch.  Tejun?
> 
> Hmm... yeah, I would much prefer if this doesn't go in this time.  I
> think we need something more generic for threadpools w/ scheduling
> restrictions.  It would be possible to retrofit so that the interface
> eventually matches but given that this feature isn't an immediate
> must-have thing, I think it would be better to not do this right now.

OK, if you have something generic for threadpools in mind, we can wait
with this one. I just thought that a "real" interface was nicer than
manual setting, especially since the flusher threads come and go. Then
you'd need some udev hook to get it set, not even sure how easy that
would be with the weird linkage.

Jeff, lets default to the node mask at least. Can you resend a patch
that doesn't add the API, but just defaults to setting the affinity to
the cpu mask of the home node?

Linus, how do you want to handle this? I can do a revert and re-send a
pull.

-- 
Jens Axboe

