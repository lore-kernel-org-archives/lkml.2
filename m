Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab0J2O3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:29:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36225 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933902Ab0J2O3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:29:11 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+QdpctWFuQ9t1knHFInfbrRI8CUqd3yA6PurRjAu
	JALI8HGN0wc+lv
Date: Fri, 29 Oct 2010 16:27:52 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Ensure FMODE_NONOTIFY is not set by userspace
Message-ID: <20101029142752.GF26242@lsanfilippo.unix.rd.tt.avira.com>
References: <20101029100217.GC26242@lsanfilippo.unix.rd.tt.avira.com> <1288360370.3017.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288360370.3017.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 09:52:50AM -0400, Eric Paris wrote:
> 
> Did you find a place where the user was able to set FMODE_NONOTIFY?
> That would be a problem.  But that's not what is happening here and
> that's not what you are fixing.

I know its not happening here, but doing something like

#define MY_FLAG 0x1000000

 open("file/within/fanotify_protection", O_RDONLY | MY_FLAG);

from userspace is all that is needed to be ignored by fanotify :)
There is nothing that checks if this flag has been set by userspace (or 
did I miss something?)

Beside this since the flag should only be set within create_fd() or
fanotify_init() there should never be a situation where 
fsnotify_open() is called with a FMODE_NONOTIFY set (by the kernel).

Regards,
Lino 
