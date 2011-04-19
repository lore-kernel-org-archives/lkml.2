Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1DSTYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:24:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50750 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145Ab1DSTYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:24:30 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX187ggA0O9k7Vn8oHQvdW4sTKoDFthJouOKn09m/je
	1aj0BZgQ04Gz4I
Date: Tue, 19 Apr 2011 21:24:27 +0200
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about
 the last build
Message-ID: <20110419192426.GA1096@debian.debian>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
 <BANLkTinn8xfyFArd4Q9aA5N47BoZ_rgCxw@mail.gmail.com>
 <BANLkTinMh7bofvSNW0gEoqaKvs27-xDGpQ@mail.gmail.com>
 <BANLkTinAres6c8JaHA0Nuijany4XXyv67A@mail.gmail.com>
 <BANLkTimoWT1K9QLs_-ucQNi1rt4e+4RYUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimoWT1K9QLs_-ucQNi1rt4e+4RYUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 12:27:29PM +0200, Francis Moreau wrote:
> On Sun, Apr 17, 2011 at 6:57 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > On Sat, Apr 16, 2011 at 10:00 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> >> On Sat, Apr 16, 2011 at 10:26 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >>> So why not just put that line into your script?
> >>>
> >>
> >> Because this line was an _example_ of how the makefile could had been invoked.
> >>
> >> But the script has currently no idea how the previous invocation was
> >> made, hence my question.
> >
> > You use a bad design, why not just pass these parameters to your script?
> > Something like,
> >
> > $ ./your_script CC=my-gcc CFLAGS="-g -fwhatever"
> >
> > or whatever you want.
> >
>
> Yes, I think I'll continue to do that.
>
> Thanks

You may also try this little script (call it instead of plain "make"):

	#!/bin/sh

	MAKE=make
	CMDLINE=make.cmdline

	if [ "x$@" != "x" ]; then
		echo -n "$@" > $CMDLINE
		$MAKE "$@"
	else
		if [ -f $CMDLINE ]; then
			$MAKE $(cat $CMDLINE)
		else
			$MAKE
		fi
	fi

thanks,
	Jonathan Neuschäfer
