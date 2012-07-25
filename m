Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab2GYIqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:46:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748Ab2GYIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:46:43 -0400
Date: Wed, 25 Jul 2012 14:16:28 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>, dlaor@redhat.com,
        Peter Maydell <peter.maydell@linaro.org>, wency@cn.fujitsu.com,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, penberg@kernel.org,
        avi@redhat.com, anthony@codemonkey.ws
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical
 events in the device
Message-ID: <20120725084628.GF9473@amit.redhat.com>
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
 <87a9yprc4v.fsf@rustcorp.com.au>
 <500E5C36.2070601@redhat.com>
 <500E954F.8090102@gmail.com>
 <500E9942.3080505@redhat.com>
 <500E9CC7.9020201@gmail.com>
 <87haswptgq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87haswptgq.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 25 Jul 2012 [10:06:37], Rusty Russell wrote:
> On Tue, 24 Jul 2012 15:01:59 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > virtio on it's own was introduced to help solve the fragmentation
> > around virtualized devices, so I don't think that the main purpose of
> > doing virtio drivers is due to any performance benefits virtio may
> > provide.
> 
> There's one argument in your favor (with my Linaro hat on): ARM wants a
> virtio reboot button, which would look remarkably similar.  There's no
> standard ARM hardware for this.
> 
> So a more generalized virtio-event device might make sense.  But there
> are almost an infinite number of guest events we might want: panics,
> oom, low memory, stuck devices, deadlock, etc, etc.  I'm concerned about
> trying to standardize them.  If we include a unspecified free-form
> string, people will end up relying on the contents.  If we add a feature
> bit for every new event, we'll end up running out of feature bits :)
> 
> CC'ing Amit for opinion over how much of this should be done via
> virtio-serial.

The prevoius discussion happend on kvm-devel; it was suggested then to
use virtio-serial for that as well.  We don't have an in-kernel
interface for communication yet (barring the console interface, which
we don't want to re-use for other reasons).

Writing the in-kernel interface for communication with the host is not
too much work as well.

I agree using virtio-serial for several such free-form message-passing
between the guest and host is the right way to implement such stuff.

The lack of dedicated devices over either virtio or emulation of
real hardware can be overcome by adding some documentation -
preferably to the virtio spec's appendix, showing how watchdogs, etc.,
are implemented using virtio-serial.

		Amit
