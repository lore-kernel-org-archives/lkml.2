Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1LWJpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:45:20 -0500
Received: from 1wt.eu ([62.212.114.60]:45125 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1LWJpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:45:17 -0500
Date: Fri, 23 Dec 2011 10:45:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
Message-ID: <20111223094502.GA24280@1wt.eu>
References: <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com> <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com> <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 01:22:24AM -0800, Linus Torvalds wrote:
> On Thu, Dec 22, 2011 at 10:26 PM, Willy Tarreau <w@1wt.eu> wrote:
> >
> > Call me dumb, but why would someone use "eject" on a non-physically
> > ejectable device such as a memory stick ?
> 
> Perhaps because that's the operation that works everywhere and is the
> simplest one?

I didn't know people were doing that. For me eject was just used to
activate the motor of ejectable devices. I've just found this in the
man which explains what you're doing and which I did not know :

       If the device is currently mounted, it is unmounted before
       ejecting.

> Just look at the icon on your desktop - it probably has "Eject" above
> the silly "Safely remove drive" when you right-click it. It has for
> me.
> 
> And I've taught myself (and my wife) to always eject media before
> removing them. I don't "unmount" them, because then for cdroms I need
> to first unmount them and then eject them. Or I'd need to do different
> operations for different devices. Both of which are just stupid.

It makes sense. However it requires setting user permissions on a device,
which "umount" would not require.

> So yes, I claim that "eject" is actually the *natural* thing to do
> before you physically remove the medium, because it works across
> different media.
> 
> But more importantly, we don't break what works. So what the f&^k was
> the point of even asking? THAT was the "dumb" thing here.

The point was that I didn't even imagine people were using this command
for this. It did not seem more natural to me than to use "mt", "chvt" or
"stty" to unmount this type of device precisely because there was no motor
to eject the device. The way you present it kind of makes sense and explains
why people are doing it this way.

Thanks,
Willy

