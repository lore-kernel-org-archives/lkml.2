Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1HRRCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:02:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41975 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1HRRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:02:44 -0400
Date: Thu, 18 Aug 2011 13:04:08 -0400
From: Jeff Layton <jlayton@samba.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also
 crashes with linux-3.1-rc2
Message-ID: <20110818130408.71c55b96@barsoom.rdu.redhat.com>
In-Reply-To: <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> 
> On Thu, 18 Aug 2011, Jeff Layton wrote:
> 
> > On Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
> > Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >
> >> Justin.
> >>
> >
> > To be clear -- incoming in this case is reads or writes?
> Reading from the CIFS share (Windows 7).
> 
> >
> > Up until 3.0 cifs.ko didn't parallelize writes from a single thread. In
> > 3.0 I added a patchset to increase the allowable wsize and to allow the
> > kernel to issue writes in parallel.
> Ahh, good to know, have not tried writes yet.
> 
> >
> > Reads still suffer from the same problem however. I'm working on a
> > patchset that should do the same thing for them, but it requires a
> > fairly substantial overhaul of the receive codepaths.
> Ok, that explains it then, thanks.
> 
> One other item, the rsync is currently running, what does mean/what option
> would fix it/make the error go away?
> 
> [ 3730.897554] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3755.727255] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3760.509489] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3760.786650] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3762.854706] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3763.052163] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3764.962962] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3765.460372] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3765.855425] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3767.677672] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3781.958450] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3800.493896] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3805.911191] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3806.121384] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3817.356127] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3825.148050] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3833.687886] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3834.199746] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3834.448342] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3866.848508] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3867.126729] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3868.428427] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3872.206396] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3872.812745] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3877.655580] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3880.718684] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3880.769545] CIFS VFS: did not end path lookup where expected namelen is 0
> [ 3882.026917] CIFS VFS: did not end path lookup where expected namelen is 0
> 
> Justin.
> 

I've sent a patch to Steve to turn those printk's into debug messages
for 3.1 and it should make its way there soon. It should be safe to
ignore them in the meantime.

In fact, that patch should probably go to 3.0-stable as well. Steve can
you add the 'Cc: stable@kernel.org' line to that patch?

-- 
Jeff Layton <jlayton@samba.org>
