Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2IYM2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:28:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2IYM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:28:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 5/6] ARM: dove: Remove watchdog from DT
Date: Tue, 25 Sep 2012 12:28:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastien Requiem <sebastien@kolios.dk>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com> <201209251120.54255.arnd@arndb.de> <87haqmgw6n.fsf@lebrac.rtp-net.org>
In-Reply-To: <87haqmgw6n.fsf@lebrac.rtp-net.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251228.25752.arnd@arndb.de>
X-Provags-ID: V02:K0:eQuPS5J3S9YmIBmcfmY8jrT9ezz1qgq4hDERLTtm1nO
 VlqoYLUoTvzT+WhqeGH7Gk7vM7907iEwkVx889tEFeqdBRLwCY
 ofz2BOKNNsxbcQ27ljNO/xUGBcSNzxgm4rsAqdhG6Mk4DNEw7e
 v5d0tNLS5H19ef3RVQNH4qxgxAB4P2tOjyFEv7RXNC3nJ/RreV
 Zn2KaXeDa8cCa6grmnyUFbxStLWKCS+olJfzwAhHSl6CvvMmzb
 3d9Y1gf/y8s3rZMFDWcokG0jlhQVVrvdzzc60ZCo4ejUtlkOgr
 7UGzhpZV5lXafctzuLZWBCsSzAMjJx9cR7AnMwix1UbbFVlkAw
 RIfbTI4rfh03WKLFO0Zw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012, Arnaud Patard wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> >
> > The next step would be to label mach-orion5x as deprecated in Kconfig for
> > a release and change the help text so it tells people to move to mach-mvebu
> > and submit dts files.
> >
> 
> You seem to imply that every user of mach-orion5x can write a dts
> file. Please don't forget that afaik some users are using the kernel
> provided by their $distribution, so if it gets broken it may be noticed
> months later. Moreover, this kind of user won't notice the Kconfig info
> as all they'll get is a binary.

The hard part is finding those users. Once we know who they are, we can
either try to help out by writing a dts file and letting them test it,
or by assisting them in the process to write one themselves.

You certainly make a good point about users that just get pre-built
binaries. Do you think we can find them by printing a warning
message from the kernel that points to some wiki page with instructions
of how to contact people and let us know what they are using?

In case of Debian, would it be possible to use an old kernel (say, 3.7)
for as long as people need to run the with the old board files, while
at the same time moving on with 3.8 and later kernels to support only
the ones that are converted to a single binary and DT booting?

> > We should let Sebastien Requiem comment. He is the only person outside of
> > Marvell who has contributed a board file for mv78xx0. If he's interested in
> > keeping it alive, he's hopefully also able to find the time to test the
> > devicetree version of that platform in mach-mvebu. Similarly, if anyone
> > has the MASA reference design, that one could be moved over to mach-mvebu
> > first.
> 
> There are some mv78xx0 (BP) dev boards used in Debian infrastructure, so
> at least, would nice to not break mv78xx0 support.

Ah, very good to know. Do you know who has access to those machines
and is willing to help out with testing? Debian is probably the party
that benefits the most from the work to move mv78xx0/kirkwood/orion5x
into a single kernel together with iop32x, versatile and vt8500, so
hopefully they can help out in with the process to get there.

We should certainly make sure we don't remove those machines as long
as Debian supports them.

	Arnd
