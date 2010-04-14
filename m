Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0DNJGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:06:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0DNJGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:06:49 -0400
Date: Wed, 14 Apr 2010 12:06:23 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: =?utf-8?B?SMOla29u?= Bugge <Haakon.Bugge@Sun.COM>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, peterz@infradead.org,
       pavel@ucw.cz, mingo@elte.hu, jsquyres@cisco.com
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Message-ID: <20100414090623.GM23554@redhat.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
 <adahbnfme0j.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <adahbnfme0j.fsf@roland-alpha.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 10:57:32AM -0700, Roland Dreier wrote:
>  > It is further claimed that "… other tricks are not robust". I wrote
>  > the code used in Scali/Platform MPI handling the issue. I do not
>  > think its fair to claim that this MPI is not robust in this matter
>  > nor that is performance is bad.
> 
> The Open MPI developers have spent a lot of effort trying to handle this
> purely in userspace and still do not believe that a truly robust
> solution is possible without kernel help.  Perhaps they can expand on
> what the obstacles are.
> 
The problem is that glibc doesn't provide correct type of hooks for MPI
to use. You can hook into free(), but the hook is called when
application frees memory, not when memory is returned back to the kernel
and since MPI wants to cache registration across free()/malloc() if
possible those hooks are not good enough. To overcome this MPI tries to
provide its own memory management library (luckily glibc defines
most/all memory management functions as weak) with proper hooks present, but
that poses a whole lot of other problems and memory management is really
not MPI's job. Even if glibc will provide proper hooks some day HPC users
may want to use other, more performance oriented, memory management
libraries instead of using build in glibc one. Relying on glibc hooks
will prevent them from doing so.

--
			Gleb.
