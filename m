Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0JYW1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:27:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0JYW1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:27:39 -0400
Message-ID: <4CC603E3.3070405@zytor.com>
Date: Mon, 25 Oct 2010 15:25:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 06/11] IMA: use i_writecount rather than a private counter
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>	 <20101025184152.20504.94048.stgit@paris.rdu.redhat.com>	 <19653.55831.692904.538148@quad.stoffel.home> <1288043557.2655.34.camel@localhost.localdomain>
In-Reply-To: <1288043557.2655.34.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 02:52 PM, Eric Paris wrote:
> On Mon, 2010-10-25 at 15:27 -0400, John Stoffel wrote:
> 
>> The problems with kernel.org is a perfect exmaple of how an annocuous
>> feature like this, can kill a system's performance.
> 
> You admit that you don't know what you are talking about and then state
> that this kills systems performance.  Interesting conclusion.
> 
> I'm not going to try to refute you point by point but will instead paint
> a broad picture.  I see 3 possible states:
> 1) Configured out - 0 overhead.  period.
> 2) Configured in but default disabled
> 3) Configured in and enabled by admin intervention
> 
> I have (I think) pretty clearly discussed the overhead and the changes
> made in case #2.  We expand struct inode by 4 bytes, we increment and
> decrement those 4 bytes on open/close() and we use a new inode->i_flags.
> 

Case #2 is the bad one, as long as distros are likely to compile it in.

	-hpa
