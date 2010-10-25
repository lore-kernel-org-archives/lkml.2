Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0JYWaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab0JYWaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:30:03 -0400
Subject: Re: [PATCH 06/11] IMA: use i_writecount rather than a private
 counter
From: Eric Paris <eparis@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <4CC603E3.3070405@zytor.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	 <20101025184152.20504.94048.stgit@paris.rdu.redhat.com>
	 <19653.55831.692904.538148@quad.stoffel.home>
	 <1288043557.2655.34.camel@localhost.localdomain>
	 <4CC603E3.3070405@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 18:29:09 -0400
Message-ID: <1288045749.2655.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:25 -0700, H. Peter Anvin wrote:
> On 10/25/2010 02:52 PM, Eric Paris wrote:
> > On Mon, 2010-10-25 at 15:27 -0400, John Stoffel wrote:
> > 
> >> The problems with kernel.org is a perfect exmaple of how an annocuous
> >> feature like this, can kill a system's performance.
> > 
> > You admit that you don't know what you are talking about and then state
> > that this kills systems performance.  Interesting conclusion.
> > 
> > I'm not going to try to refute you point by point but will instead paint
> > a broad picture.  I see 3 possible states:
> > 1) Configured out - 0 overhead.  period.
> > 2) Configured in but default disabled
> > 3) Configured in and enabled by admin intervention
> > 
> > I have (I think) pretty clearly discussed the overhead and the changes
> > made in case #2.  We expand struct inode by 4 bytes, we increment and
> > decrement those 4 bytes on open/close() and we use a new inode->i_flags.
> > 
> 
> Case #2 is the bad one, as long as distros are likely to compile it in.

Agreed.  And that's the case this whole patch series is addressing.  It
makes it (literally not figuratively) hundreds of times better than it
is today  :)

-Eric

