Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0HRPre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:47:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:60388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0HRPrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:31 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Wed, 18 Aug 2010 17:47:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com> <201008162232.36873.agruen@suse.de>
In-Reply-To: <201008162232.36873.agruen@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181747.15461.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

one more thing that doesn't make sense is events on directories: when watching 
a directory, some actions like reading a directory or creat()ing a file in the 
directory will generate events (even open_perm and access_perm), but other 
actions like hard linking files into the directory or removing files will not 
create any events.  This means that fanotify currently cannot be used for 
watching for directory changes.

In my opinion, events on directories should either be made to actually work, 
or else no directory events at all should be generated.

Also, I can think of users of fanotify which are not concerned with directory 
events at all.  It would make sense to allow such users to subscribe only to 
file events and not receive any directory events which they will end up 
ignoring anyway.

Again it shows that this code just wasn't ready to be merged yet ...

Andreas
