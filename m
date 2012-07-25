Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab2GYDZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:25:52 -0400
Received: from ozlabs.org ([203.10.76.45]:40774 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab2GYDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:25:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, dlaor@redhat.com
Cc: mst@redhat.com, penberg@kernel.org, asias.hejun@gmail.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        anthony@codemonkey.ws, wency@cn.fujitsu.com,
        "Peter Maydell" <peter.maydell@linaro.org>,
        "Amit Shah" <amit.shah@redhat.com>
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical events in the device
In-Reply-To: <500E9CC7.9020201@gmail.com>
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com> <87a9yprc4v.fsf@rustcorp.com.au> <500E5C36.2070601@redhat.com> <500E954F.8090102@gmail.com> <500E9942.3080505@redhat.com> <500E9CC7.9020201@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 25 Jul 2012 10:06:37 +0930
Message-ID: <87haswptgq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2012 15:01:59 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> virtio on it's own was introduced to help solve the fragmentation
> around virtualized devices, so I don't think that the main purpose of
> doing virtio drivers is due to any performance benefits virtio may
> provide.

There's one argument in your favor (with my Linaro hat on): ARM wants a
virtio reboot button, which would look remarkably similar.  There's no
standard ARM hardware for this.

So a more generalized virtio-event device might make sense.  But there
are almost an infinite number of guest events we might want: panics,
oom, low memory, stuck devices, deadlock, etc, etc.  I'm concerned about
trying to standardize them.  If we include a unspecified free-form
string, people will end up relying on the contents.  If we add a feature
bit for every new event, we'll end up running out of feature bits :)

CC'ing Amit for opinion over how much of this should be done via
virtio-serial.

Cheers,
Rusty.
