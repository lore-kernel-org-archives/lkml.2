Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2LQTHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:07:45 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53132
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343Ab2LQTHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:07:44 -0500
Message-ID: <50CF6D7C.2000300@kernel.dk>
Date: Mon, 17 Dec 2012 20:07:40 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jeff Moyer <jmoyer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com> <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk> <20121217174717.GC2592@htj.dyndns.org>
In-Reply-To: <20121217174717.GC2592@htj.dyndns.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-17 18:47, Tejun Heo wrote:
> Hello, Jens.
> 
> On Mon, Dec 17, 2012 at 06:04:42PM +0100, Jens Axboe wrote:
>> OK, if you have something generic for threadpools in mind, we can wait
>> with this one. I just thought that a "real" interface was nicer than
>> manual setting, especially since the flusher threads come and go. Then
>> you'd need some udev hook to get it set, not even sure how easy that
>> would be with the weird linkage.
> 
> I've been thinking about this and I think what we really need is a
> generic interface for thread pools where the user can specify various
> attributes - priority, affinity and probably cgroup association, so
> that those attributes are exposed in generic manner while backend
> creates and manages worker pools identified by actual attriutes so
> that we don't end up with gazillion pools.  crypto and writeback would
> be the obvious users and probably the virtio too.  I'll write more
> when things get more concrete.

I agree. That part of the writeback code is pretty generic
functionality.

So new course of action is to revert the commit, and then I'm sure Jeff
will re-send the code to just set the affinity to something sane by
default when that is easily doable.

-- 
Jens Axboe

