Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2LQTGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:06:36 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53127
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109Ab2LQTGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:06:35 -0500
Message-ID: <50CF6D35.5040300@kernel.dk>
Date: Mon, 17 Dec 2012 20:06:29 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com> <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk> <x49ehiowqga.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ehiowqga.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-17 18:15, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 2012-12-17 18:00, Tejun Heo wrote:
>>> On Mon, Dec 17, 2012 at 11:06:39AM -0500, Jeff Moyer wrote:
>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>
>>>>> - Export control of bdi flusher thread CPU mask and default to using the
>>>>>   home node (if known) from Jeff.
>>>>
>>>> I certainly wouldn't mind this going in, but I think Tejun NACKed this
>>>> patch.  Tejun?
>>>
>>> Hmm... yeah, I would much prefer if this doesn't go in this time.  I
>>> think we need something more generic for threadpools w/ scheduling
>>> restrictions.  It would be possible to retrofit so that the interface
>>> eventually matches but given that this feature isn't an immediate
>>> must-have thing, I think it would be better to not do this right now.
>>
>> OK, if you have something generic for threadpools in mind, we can wait
>> with this one. I just thought that a "real" interface was nicer than
>> manual setting, especially since the flusher threads come and go. Then
>> you'd need some udev hook to get it set, not even sure how easy that
>> would be with the weird linkage.
>>
>> Jeff, lets default to the node mask at least. Can you resend a patch
>> that doesn't add the API, but just defaults to setting the affinity to
>> the cpu mask of the home node?
> 
> Well, it turns out that the numa node is always -1, since bdi devices
> always have a null parent.  I have a patch set to clean that up, but it
> depends on my other numa patches in the scsi area that will hopefully
> go in 3.9.

Sigh, in that case, yes lets just revert it.

-- 
Jens Axboe

