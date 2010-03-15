Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548Ab0CORTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:19:38 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44498 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965445Ab0CORTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:19:37 -0400
Date: Mon, 15 Mar 2010 13:17:49 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Daniel Baluta <daniel.baluta@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kfifo has temporarily invalid in pointer?
In-Reply-To: <413a6a951003150906ve38d1dy95ed07f026accf09@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003151315580.11348@localhost>
References: <alpine.LFD.2.00.1003151044590.8729@localhost> <413a6a951003150906ve38d1dy95ed07f026accf09@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1371127320-1268673472=:11348"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1371127320-1268673472=:11348
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 15 Mar 2010, Daniel Baluta wrote:

> Hi Robert,
>
> On Mon, Mar 15, 2010 at 4:58 PM, Robert P. J. Day <rpjday@crashcourse.ca>=
 wrote:
> >
> > =A0(i am not trying to be annoyingly obsessive about the kernel kfifo,
> > i am merely succeeding.)
> :P
> > =A0what appears to be a bit of an oddity WRT kfifo: =A0since a kfifo is
> > defined with a fixed buffer size, it obviously enqueues and dequeues
> > in a circular fashion. =A0so, the code to add some data to a kfifo (fro=
m
> > kernel/kfifo.c):
> >
> > =3D=3D=3D=3D=3D
> > unsigned int kfifo_in(struct kfifo *fifo, const void *from,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned=
 int len)
> > {
> > =A0 =A0 =A0 =A0len =3D min(kfifo_avail(fifo), len);
> >
> > =A0 =A0 =A0 =A0__kfifo_in_data(fifo, from, len, 0);
> > =A0 =A0 =A0 =A0__kfifo_add_in(fifo, len);
> > =A0 =A0 =A0 =A0return len;
> > }
> > =3D=3D=3D=3D=3D
> >
> > =A0fair enough -- that first routine adds the data itself, while the
> > second one correspondingly bumps up the pointer, which could
> > conceivably wrap around to follow the data, correct? =A0but from
> > include/linux.kfifo.h:len =3D min(kfifo_avail(fifo), len);
>
> Wrong :). If you notice len is truncated using:
> len =3D min(kfifo_avail(fifo), len);

  kfifo_avail() is defined as returning the number of available bytes
left in the buffer ready to accept incoming data, even if that
incorporates wraparound.  that is not relevant to the point i was
making.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-1371127320-1268673472=:11348--
