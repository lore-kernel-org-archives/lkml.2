Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab0JZOC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:02:29 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47936 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0JZOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:02:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19654.57160.616600.480900@quad.stoffel.home>
Date: Tue, 26 Oct 2010 10:01:44 -0400
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, "J.H." <warthog9@kernel.org>,
        John Stoffel <john@stoffel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zohar@us.ibm.com, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
In-Reply-To: <AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<19653.55494.240658.165153@quad.stoffel.home>
	<4CC5DCBB.1070505@kernel.org>
	<AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com>
	<20101025205746.GA6568@infradead.org>
	<AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> On Mon, Oct 25, 2010 at 1:57 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> 
>> Kyle sent a very useful patch to simply disable the ima tracking unless
>> you enable it on the command line.

Linus> And exactly how does that invalidate _any_ of the patches in
Linus> the IMA series in question? All of them are basically still
Linus> equally valid.

Well, if we're going to keep IMA as an option, then this cleanup is
certainly worthwhile.   And keeping it's impact down as much as
possible is even better.  

Linus> And the "four bytes in 'struct inode' is a total no-no" crowd
Linus> clearly haven't looked at struct inode. As mentioned, we've got
Linus> things like quota stuff there too.

Quota is arguably much more useful than IMA, and to a much larger
audience.  There's a reason it's in there.  As a SysAdmin, one of my
major gripes is how hard it is to manage disk space usage by my users
and track it in useful ways.

Quotas allow me to do a quicker, more targeted response when disk
space fills up and I need to find the biggest users.  Would I like
better quota reporting?  Sure!  Do I want more overhead, not so much.
It's a balancing act.

Linus> And quite frankly, it sounds like the right thing to do for
Linus> Fedora &co is to simply _disable_ CONFIG_IMA. If there is no
Linus> support for it on a distro level, then you shouldn't enable it.

So the Kconfig should have 'default N' for IMA then?

John

