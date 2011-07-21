Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1GUTmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:42:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab1GUTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:42:07 -0400
Date: Thu, 21 Jul 2011 21:41:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Add support to install perf python extension
Message-ID: <20110721194150.GB2425@jolsa.Belkin>
References: <1311266726-20655-1-git-send-email-jolsa@redhat.com>
 <20110721171148.GB24324@ghostprotocols.net>
 <20110721184715.GA2425@jolsa.Belkin>
 <20110721190407.GC24324@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721190407.GC24324@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:04:07PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 21, 2011 at 08:47:15PM +0200, Jiri Olsa escreveu:
> > On Thu, Jul 21, 2011 at 02:11:48PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Jul 21, 2011 at 06:45:26PM +0200, Jiri Olsa escreveu:
> > > > Changing the distutils to use their own default 'build'
> > > > directory.
> > > > 
> > > > Such setup makes the install command simple, because using
> > > > --build-lib and --build-temp does not seem to comply with
> > > > the way the distutils' install commands expect it.
> > > > 
> > > > Also keeping the python/perf.so file, so it could be used
> > > > for testing as of until now.
> > > 
> > > Yeah, I gave up when I couldn't get:
> > > 
> > > $ make O=/tmp/build-dir-for-perf/ -C tools/perf/ install
> > > 
> > > to work, does it now? Checking...
> > 
> > nope, I added install-python_ext since it installs to the
> > python system lib area, and it could break standard install
> 
> But where is that it picks the binaries built? The problem I was
> experiencing was that it wasn't obeying O=, just using the source dir

I haven't checked the 'O=' that much.. will do :)

> as the build dir, effectively building it again, in a different place.

I dont have that much experince with python, but here's what I found:
(might be missing something..)

build_ext command
- build_ext will by default create a 'build' directory and 
  put all the stuff in - temp and final dirs/binary
- you can overload this with build-lib/build-temp options

install command
- install does not have option to specify the build-lib directory
  (but it has the --root option that we need)
- so running just install assumes you have used default 'build'
  directory and if it does not exist it starts rebuild
- there's another command install_lib, which let's you specify
  the build-lib.. BUT it wont let you specify the --root option ;)

There's possibility to use setup.cfg file and generate/put options
for each command, so at the end we could choose what directory to use.

Also there might be a way to overload distutils class and put our
specific options to this new class..

As I checked some of python extension packages, some of them
do not use distutils at all.. can't imagine why ;)

jirka

>  
> > I think there's a way to install python modules under $HOME,
> > maybe we could do that if no DESTDIR is specified..
> > I can add it later ;)
> 
> Right, but this is not what I was talking about :-)
> 
> - Arnaldo
