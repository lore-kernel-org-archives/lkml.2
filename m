Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab1GUTEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1GUTEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:04:24 -0400
Date: Thu, 21 Jul 2011 16:04:07 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Add support to install perf python
	extension
Message-ID: <20110721190407.GC24324@ghostprotocols.net>
References: <1311266726-20655-1-git-send-email-jolsa@redhat.com> <20110721171148.GB24324@ghostprotocols.net> <20110721184715.GA2425@jolsa.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721184715.GA2425@jolsa.Belkin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 21, 2011 at 08:47:15PM +0200, Jiri Olsa escreveu:
> On Thu, Jul 21, 2011 at 02:11:48PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jul 21, 2011 at 06:45:26PM +0200, Jiri Olsa escreveu:
> > > Changing the distutils to use their own default 'build'
> > > directory.
> > > 
> > > Such setup makes the install command simple, because using
> > > --build-lib and --build-temp does not seem to comply with
> > > the way the distutils' install commands expect it.
> > > 
> > > Also keeping the python/perf.so file, so it could be used
> > > for testing as of until now.
> > 
> > Yeah, I gave up when I couldn't get:
> > 
> > $ make O=/tmp/build-dir-for-perf/ -C tools/perf/ install
> > 
> > to work, does it now? Checking...
> 
> nope, I added install-python_ext since it installs to the
> python system lib area, and it could break standard install

But where is that it picks the binaries built? The problem I was
experiencing was that it wasn't obeying O=, just using the source dir
as the build dir, effectively building it again, in a different place.
 
> I think there's a way to install python modules under $HOME,
> maybe we could do that if no DESTDIR is specified..
> I can add it later ;)

Right, but this is not what I was talking about :-)

- Arnaldo
