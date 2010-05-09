Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0EIVLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 17:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0EIVLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 17:11:23 -0400
Date: Mon, 10 May 2010 00:06:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH RFC] virtio: put last seen used index into ring itself
Message-ID: <20100509210652.GB21338@redhat.com>
References: <20100505205814.GA7090@redhat.com> <201005061201.35223.rusty@rustcorp.com.au> <20100506061945.GA8363@redhat.com> <201005071303.29129.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005071303.29129.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 01:03:28PM +0930, Rusty Russell wrote:
> On Thu, 6 May 2010 03:49:46 pm Michael S. Tsirkin wrote:
> > Now, I also added an mb() in guest between read and write so
> > that last used index write can not get ahead of used index read.
> > It does feel good to have it there, but I can not say why
> > it's helpful. Works fine without it, but then these
> > subtle races might be hard to trigger. What do you think?
> 
> I couldn't see that in the patch?  I don't think it's necessary
> though, since the write of depends last_used depends on the read of
> used (and no platform we care about would reorder such a thing).

Well, there's no data dependency, is there?

> I'm reasonably happy, but we should write some convenient test for
> missing interrupts.
> 
> I'm thinking of a sender which does a loop: blasts 1MB of UDP packets,
> then prints the time and sleep(1).  The receiver would print the time
> every 1MB of received data.  The two times should almost exactly correspond.
> 
> Assuming that the network doesn't overflow and lose stuff, this should
> identify any missing wakeup/interrupts (depending on direction used).
> 
> Cheers,
> Rusty.
