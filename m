Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0DMXyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:54:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60243
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0DMXyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:54:23 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] Add somaxconn to Documentation/sysctl/net.txt
Date: Tue, 13 Apr 2010 18:54:13 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-18-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
References: <201004131325.29104.rob@landley.net> <1271184012.16881.549.camel@edumazet-laptop>
In-Reply-To: <1271184012.16881.549.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201004131854.14082.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 April 2010 13:40:12 Eric Dumazet wrote:
> Le mardi 13 avril 2010 à 13:25 -0500, Rob Landley a écrit :
> > From: Rob Landley <rob@landley.net>
> >
> > Add somaxconn to Documentation/sysctl/net.txt
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
> > ---
> >
> >  Documentation/sysctl/net.txt |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.txt
> > index df38ef0..2740085 100644
> > --- a/Documentation/sysctl/net.txt
> > +++ b/Documentation/sysctl/net.txt
> > @@ -90,6 +90,12 @@ optmem_max
> >  Maximum ancillary buffer size allowed per socket. Ancillary data is a
> > sequence of struct cmsghdr structures with appended data.
> >
> > +somaxconn
> > +---------
> > +
> > +Maximum backlog of unanswered connections for a listening socket. 
> > Provides +an upper bound on the "backlog" parameter of the listen()
> > syscall. +
> >  2. /proc/sys/net/unix - Parameters for Unix domain sockets
> >  -------------------------------------------------------
>
> Please cc netdev for such patches
>
> Extract of Documentation/networking/ip-sysctl.txt
>
> somaxconn - INTEGER
> 	Limit of socket listen() backlog, known in userspace as SOMAXCONN.
> 	Defaults to 128.  See also tcp_max_syn_backlog for additional tuning
> 	for TCP sockets.
>
> I guess you need to change both files ?

Dunno.  I just got a question on the busybox mailing list:

  http://lists.busybox.net/pipermail/busybox/2010-April/072090.html

Looked in Documentation to see what /proc/sys/net/core/somaxconn actually 
_did_, found it was undocumented, grepped the kernel source for somaxconn, 
found just one chunk of code actually using it, replied to the guy's question:

  http://lists.busybox.net/pipermail/busybox/2010-April/072096.html

And then tweaked the documentation with what I'd found, and sent in a doc 
patch so I wouldn't have to do that twice.

It's quite possible I got it wrong.  Maybe it's per interface or something?

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
