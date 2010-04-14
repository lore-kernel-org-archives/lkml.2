Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0DNOp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:45:59 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:39245 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab0DNOp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:45:57 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 10:45:57 EDT
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,204,1270425600"; 
   d="scan'208";a="101547871"
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Jeff Squyres <jsquyres@cisco.com>
In-Reply-To: <20100414090623.GM23554@redhat.com>
Date: Wed, 14 Apr 2010 10:36:21 -0400
Cc: "Roland Dreier (rdreier)" <rdreier@cisco.com>,
       =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge@Sun.COM>,
       "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric B Munson" <ebmunson@us.ibm.com>, <linux-kernel@vger.kernel.org>,
       <linux-rdma@vger.kernel.org>, <rolandd@cisco.com>,
       <peterz@infradead.org>, <pavel@ucw.cz>, <mingo@elte.hu>
Content-Transfer-Encoding: 8BIT
Message-Id: <7A16511A-25C7-4850-9E1A-2EFE53DAF6A4@cisco.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com> <20100412160359.1d9074dc.akpm@linux-foundation.org> <20100412235937.GF15629@obsidianresearch.com> <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com> <adahbnfme0j.fsf@roland-alpha.cisco.com> <20100414090623.GM23554@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14, 2010, at 5:06 AM, Gleb Natapov wrote:

> > The Open MPI developers have spent a lot of effort trying to handle this
> > purely in userspace and still do not believe that a truly robust
> > solution is possible without kernel help.  Perhaps they can expand on
> > what the obstacles are.

By "truly robust" we mean that some other user-level code can't override the hooks installed by the MPI (user level) middleware.  All current glibc hooks are overridable by other user-level code -- and sometimes real applications do this (for their own good reasons).  Most of the time, apps blithely override our hooks because they either don't know or can't know that our hooks are installed.  It can be dicey to know what you can and cannot override pre-main(), for example (e.g., via the __malloc_initialize_hook).

Opening up a direct channel to the kernel and saying "hey, tell me when something changes" is robust because no other entity can hijack your notifications.  It also allows us to avoid using pre-main hooks, and makes it so that we don't have to hook into the memory subsystem (usually replacing it with our own).  Both of these things are extremely distasteful -- fixing these two things alone make doing something like ummunotify worthwhile, IMHO.

-- 
Jeff Squyres
jsquyres@cisco.com
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

