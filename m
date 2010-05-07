Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0EGDdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:33:38 -0400
Received: from ozlabs.org ([203.10.76.45]:43900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0EGDdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:33:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC] virtio: put last seen used index into ring itself
Date: Fri, 7 May 2010 13:03:28 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20100505205814.GA7090@redhat.com> <201005061201.35223.rusty@rustcorp.com.au> <20100506061945.GA8363@redhat.com>
In-Reply-To: <20100506061945.GA8363@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005071303.29129.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 03:49:46 pm Michael S. Tsirkin wrote:
> Now, I also added an mb() in guest between read and write so
> that last used index write can not get ahead of used index read.
> It does feel good to have it there, but I can not say why
> it's helpful. Works fine without it, but then these
> subtle races might be hard to trigger. What do you think?

I couldn't see that in the patch?  I don't think it's necessary
though, since the write of depends last_used depends on the read of
used (and no platform we care about would reorder such a thing).

I'm reasonably happy, but we should write some convenient test for
missing interrupts.

I'm thinking of a sender which does a loop: blasts 1MB of UDP packets,
then prints the time and sleep(1).  The receiver would print the time
every 1MB of received data.  The two times should almost exactly correspond.

Assuming that the network doesn't overflow and lose stuff, this should
identify any missing wakeup/interrupts (depending on direction used).

Cheers,
Rusty.
