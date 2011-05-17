Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1EQWqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:46:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48031 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932419Ab1EQWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:46:07 -0400
X-Sasl-enc: yTZFmkX6vT6A1XlX42MCnpRY0odza33Q7R2PZWESMtY1 1305672366
Date: Tue, 17 May 2011 15:45:25 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] package: Makefile: add USB/IP userspace utilities
Message-ID: <20110517224525.GA16275@kroah.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
 <5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
 <20110517202300.GA7981@kroah.com>
 <BANLkTimCEFEVmdQM9J1=0QRE2NFcim6fAw@mail.gmail.com>
 <20110517212122.GA13484@kroah.com>
 <BANLkTimZ8gvVaRz3HPqdJnOwAz2K6iuJSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimZ8gvVaRz3HPqdJnOwAz2K6iuJSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 02:59:29PM -0700, matt mooney wrote:
> On Tue, May 17, 2011 at 2:21 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, May 17, 2011 at 02:13:01PM -0700, matt mooney wrote:
> >> On Tue, May 17, 2011 at 1:23 PM, Greg KH <greg@kroah.com> wrote:
> >> > On Sat, May 14, 2011 at 03:55:20AM -0700, matt mooney wrote:
> >> >> From: matt mooney <mfm@muteddisk.com>
> >> >>
> >> >> Add usbip-src-pkg target to generate a tarball of the userspace source.
> >> >>
> >> >> Signed-off-by: matt mooney <mfm@muteddisk.com>
> >> >> ---
> >> >>  scripts/package/Makefile |   15 ++++++++++++++-
> >> >
> >> > Is this really needed at this point in time?  I'd prefer to wait on it
> >> > before we get this code cleaned up a bit better if you don't mind.
> >>
> >> Oh yeah, of course. I only added it because I thought you wanted me to
> >> add it now.
> >
> > For some reason I thought it would be more, but there really isn't a way
> > to build the userspace code from the main root of the kernel tree is
> > there?
> 
> I do not believe there is. Since `make ...' starts the Kbuild system,
> Kbuild would have to support this otherwise we would have to
> circumvent the build system. And the closest thing to some kind of
> support I could find was in scripts/Makefile.host, but it says it is
> for binaries used during the kernel compilation process. I think this
> set of userspace utilities is further complicated by its use of
> autotools.
> 
> My use of "circumvent the build system" may be a bit harsh. I don't
> think there is anything wrong with running a parameterized instance of
> make within a target, but the short answer would be that this problem
> does not seem to have been generalized in Kbuild yet.

Ok, that's fine, I originally thought that tools like perf were somehow
hooked up to the main Makefile, when it seems they really aren't.  So
your other patches are fine, and are now applied.

We can wait on the tarball extract when the code moves into the "real"
part of the kernel.

thanks,

greg k-h
