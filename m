Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab0JZN6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:58:24 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47872 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab0JZN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:58:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19654.56921.305451.776696@quad.stoffel.home>
Date: Tue, 26 Oct 2010 09:57:45 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, John Stoffel <john@stoffel.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 06/11] IMA: use i_writecount rather than a private
 counter
In-Reply-To: <1288045749.2655.49.camel@localhost.localdomain>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<20101025184152.20504.94048.stgit@paris.rdu.redhat.com>
	<19653.55831.692904.538148@quad.stoffel.home>
	<1288043557.2655.34.camel@localhost.localdomain>
	<4CC603E3.3070405@zytor.com>
	<1288045749.2655.49.camel@localhost.localdomain>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> On Mon, 2010-10-25 at 15:25 -0700, H. Peter Anvin wrote:
>> On 10/25/2010 02:52 PM, Eric Paris wrote:
>> > On Mon, 2010-10-25 at 15:27 -0400, John Stoffel wrote:
>> > 
>> >> The problems with kernel.org is a perfect exmaple of how an annocuous
>> >> feature like this, can kill a system's performance.
>> > 
>> > You admit that you don't know what you are talking about and then state
>> > that this kills systems performance.  Interesting conclusion.
>> > 
>> > I'm not going to try to refute you point by point but will instead paint
>> > a broad picture.  I see 3 possible states:
>> > 1) Configured out - 0 overhead.  period.
>> > 2) Configured in but default disabled
>> > 3) Configured in and enabled by admin intervention
>> > 
>> > I have (I think) pretty clearly discussed the overhead and the changes
>> > made in case #2.  We expand struct inode by 4 bytes, we increment and
>> > decrement those 4 bytes on open/close() and we use a new inode->i_flags.
>> > 
>> 
>> Case #2 is the bad one, as long as distros are likely to compile it in.

Eric> Agreed.  And that's the case this whole patch series is addressing.  It
Eric> makes it (literally not figuratively) hundreds of times better than it
Eric> is today  :)

And just to chime in, I really appreciate your hard work on this
cleanup!

John
