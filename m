Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab0JZNqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:46:35 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47676 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0JZNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:46:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19654.56165.616805.136152@quad.stoffel.home>
Date: Tue, 26 Oct 2010 09:45:09 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
In-Reply-To: <1288042483.2655.16.camel@localhost.localdomain>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<19653.55494.240658.165153@quad.stoffel.home>
	<1288042483.2655.16.camel@localhost.localdomain>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> On Mon, 2010-10-25 at 15:21 -0400, John Stoffel wrote:
>> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

>> Which seems to fly in the face of your claim that it needs to be able
>> to re-enable itself by tracking open inodes even when disabled.

Eric> You're confusing multiple completely unrelated things.  Your
Eric> confusing loading an IMA measurement policy vs IMA indicating
Eric> that it's measurements may be unreliable.

So educate me (and the rest of LKML) about these differences and what
they mean.  Can you please add in a patch to this series which puts in
some documentation on how and why to use this stuff?

And can you also change the Kconfig to default to 'N' for this feature
too!  The help text says to say 'N' by default, so that should be the
default, right?

>> As the number of inodes goes up (say during a backup which reads
>> them...) won't the size of this cache go up as well, even when IMA is
>> disabled?  Why is this overhead even needed?

Eric> At the end of this patch the number of integrity structures
Eric> still has a 1-1 mapping with the number of inodes.  If you look
Eric> at the entire series you will see that is not the case.

Eric> This patch by itself will cut the memory usage per inode by
Eric> almost 600 bytes.

That's a good thing then.  

John
