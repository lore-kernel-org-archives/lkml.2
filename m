Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2JJL0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab2JJL0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:26:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121009183908.1e402a43@infradead.org>
References: <20121009183908.1e402a43@infradead.org> <30699.1349789424@warthog.procyon.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: dhowells@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] Disintegrate UAPI for media
Date: Wed, 10 Oct 2012 12:26:27 +0100
Message-ID: <5255.1349868387@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hmm... last year, it was decided that we would be putting the DVB av7110-only
> API files on a separate place, as the API there conflicts with V4L/alsa APIs
> and are used only by one upstream driver (there were two drivers using them,
> at that time). As you might notice, av7110 hardware is really old, not 
> manufactured anymore since maybe 10 years ago, and it is an unmaintained
> driver.
> 
> Some developers complained, arguing that moving it to a separate file would
> be breaking the compilation on existing tools (they're basically concerned
> with it due to out-of-tree drivers - mostly propietary ones, that use this
> API).

As long as they're relying on the -I flags provided by the build tree, that
oughtn't to be a problem.  If they're doing their own -I flags, they'll need
to add -I include/uapi too (_after_ -I include).

> Now that we're moving everything, it does make sense to do that, moving 
> dvb/(audio|osd|video).h to someplace else (maybe linux/dvb/av7110.h or
> linux/dvb/legacy/*.h).

Do you want me to do anything?  I should be able to incorporate a patch prior
to the disintegration of linux/dvb/ if you have one.

David
