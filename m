Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab0J2QKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0J2QKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:10:11 -0400
Subject: Re: Ensure FMODE_NONOTIFY is not set by userspace
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101029142752.GF26242@lsanfilippo.unix.rd.tt.avira.com>
References: <20101029100217.GC26242@lsanfilippo.unix.rd.tt.avira.com>
	 <1288360370.3017.15.camel@localhost.localdomain>
	 <20101029142752.GF26242@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 12:10:07 -0400
Message-ID: <1288368607.3017.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 16:27 +0200, Lino Sanfilippo wrote:
> On Fri, Oct 29, 2010 at 09:52:50AM -0400, Eric Paris wrote:
> > 
> > Did you find a place where the user was able to set FMODE_NONOTIFY?
> > That would be a problem.  But that's not what is happening here and
> > that's not what you are fixing.
> 
> I know its not happening here, but doing something like
> 
> #define MY_FLAG 0x1000000
> 
>  open("file/within/fanotify_protection", O_RDONLY | MY_FLAG);
> 
> from userspace is all that is needed to be ignored by fanotify :)
> There is nothing that checks if this flag has been set by userspace (or 
> did I miss something?)
> 
> Beside this since the flag should only be set within create_fd() or
> fanotify_init() there should never be a situation where 
> fsnotify_open() is called with a FMODE_NONOTIFY set (by the kernel).

You're right, I'm still not sure this is the best way to fix it, but
it's very broken.  I'll either commit your patch or post my own
today....

-Eric

