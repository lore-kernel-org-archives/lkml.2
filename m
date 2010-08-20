Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab0HTFUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:20:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24032 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0HTFUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:20:09 -0400
Subject: Re: [GIT PULL] notification tree: directory events
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
Date: Thu, 19 Aug 2010 23:19:07 -0600
Cc: Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5FB2A21F-95D3-4B99-A521-74346EEEAF5B@dilger.ca>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008191444.08966.agruen@suse.de> <1282230012.21419.1566.camel@acb20005.ipt.aol.com> <201008200141.10068.agruen@suse.de> <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
To: Eric Paris <eparis@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-19, at 21:38, Eric Paris wrote:
> On Fri, 2010-08-20 at 01:41 +0200, Andreas Gruenbacher wrote:
>> Being able to identify the object that an event refers to is important.  There 
>> are two ways to do that:
>> 
>> 	(1) Include fields like st_dev and st_ino in struct
>> 	    fanotify_event_metadata.
> 
> On a more realistic note, I'm not opposed to (1), however, your
> arguments would lead one to reject inotify as the IN_OVERFLOW or oom
> conditions will result in silently lost events or events which provide
> no useful information since the notification system has broken down.
> When the appropriate use of notification is impossible I'm certainly not
> opposed to patches which add best effort information, but you are
> already outside the bounds of a reasonably functional system and there
> is no good solution.

What about unifying the file identification here with the file handle used for open_by_handle()?  That keeps a consistent identifier for the inode between multiple system calls (always a good thing), and allows the inode to be opened again via open_by_handle() if needed.

Cheers, Andreas





