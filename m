Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577Ab0JZWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 18:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43425 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760338Ab0JZWJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 18:09:57 -0400
Message-ID: <4CC75155.4060807@zytor.com>
Date: Tue, 26 Oct 2010 15:08:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 06/11] IMA: use i_writecount rather than a private counter
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>	<20101025184152.20504.94048.stgit@paris.rdu.redhat.com>	<19653.55831.692904.538148@quad.stoffel.home>	<1288043557.2655.34.camel@localhost.localdomain> <19654.56681.488563.135215@quad.stoffel.home>
In-Reply-To: <19654.56681.488563.135215@quad.stoffel.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 06:53 AM, John Stoffel wrote:
> 
> No.  What I was trying to get at, and probably poorly, was the comment
> you made about having to keep the IMA data structures around, even if
> IMA has been disabled, so that you could continue to claim integrity
> if IMA was re-enabled.
> 
> So my question is really about the following situation:
> 
> 1.  System boots up, IMA is enabled.
> 2.  SysAdmin notices and turns it off.
>     - does the IMA overhead (not the per-inode 4 bytes) go away?
>     - do the various in memory data structures get freed?
>     - does the pointer in the inode get null'ed?
> 

I think it's reasonable to require a reboot in this case.

	-hpa
