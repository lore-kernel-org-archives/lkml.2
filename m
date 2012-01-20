Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2ATPxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:53:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60684 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab2ATPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:53:24 -0500
Date: Fri, 20 Jan 2012 09:53:18 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: radeon issues on MacBook Pro 8,2
Message-ID: <20120120155318.GA8162@ubuntu-macmini>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20120119171808.GB23144@ubuntu-macmini>
 <CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com>
 <20120119205317.GC23144@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120119205317.GC23144@ubuntu-macmini>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:53:17PM -0600, Seth Forshee wrote:
> > >  2. Occasional long delays when suspending. When this happens I see
> > >    messages like following in dmesg:
> > >
> > >      [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
> > >      [drm:atom_execute_table_locked] *ERROR* atombios stuck executing D44E (len 62, WS 0, PS 0) @ 0xD46A
> > >
> > >    Sometimes one of suspend or resume hangs completely, but I can't
> > >    tell which and am not sure whether or not it's related. I'm also
> > >    testing a Mac Mini with the exact same card which does not seem to
> > >    suffer from this issue.
> > >
> > >    I ran a bisections that identified f8d0edd (drm/radeon/kms: improve
> > >    DP detect logic) as introducing problems with suspend, and reverting
> > >    this patch on top of 3.2.1 does seem to eliminate both issues.
> > >
> > 
> > That patch doesn't really affect the modesetting paths directly; it
> > looks like a red herring to me.
> 
> Perhaps. I just started a run of 200 s3 cycles with the patch reverted
> to see if I can reproduce the issues. I can usually trigger the problem
> with 15 or fewer s3 cycles.

The machine completed 200 s3 cycles with the patch reverted without long
delays, hangs, or any atombios error messages. Without reverting it
doesn't get through many at all before experiencing the errors and long
delays or hangs. 

I added a printout of the connector status resulting from the logic that
was changed by f8d0edd. With the logic prior to this commit it
consistently returns the status as disconnected, which is correct as I
have nothing connected. But with the improved logic the status is
sometimes reported as connected, and these coincide with the atombios
errors.

Seth
