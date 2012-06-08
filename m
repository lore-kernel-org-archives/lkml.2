Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176Ab2FHPVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:21:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab2FHPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:21:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] delete seven tty headers
Date: Fri, 8 Jun 2012 14:03:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <1339145808.25798.28.camel@x61.thuisdomein> <4FD1DB30.80307@suse.cz> <1339155706.25798.55.camel@x61.thuisdomein>
In-Reply-To: <1339155706.25798.55.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206081403.16608.arnd@arndb.de>
X-Provags-ID: V02:K0:iC2S48uX2r5/YOUSEVLQ/n6c+DLzBAOr7iqRFC67HNu
 RGI1SaCXsESTqE1pr2ygyG978YC/HB6iNZ5o49QiZPWQlDrj05
 O/ec6XYot6aW618lGulFVVckYnPlw17zL3K+o2rbuUxcLYW6lc
 /s0fkMM/OYh0QvElboAdyA4s4xsPd66Z+l6Exz6G0dX56A+6GW
 OZMNoA99J63XsxQSTbFHddYiidiwbiY1afrmcr0H1szHJLmrC7
 b2yi3x3y19czoxM3zvUn0S6ISfco9wrXJOqN2JoBjskqwnShvm
 X4FHMoL3bTNQxidetuzRIr2bfRisdszWP3zCXGDFbg8EO4wYlf
 FQs8ywgrRh135b8yp5Jw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2012, Paul Bolle wrote:
> > I doubt there are any users at all, but we still should
> > gave them a chance to fix their builds (remove those #include's and
> > potentially used defined/structs) and not introduce a userspace build
> > breakage.
> 
> I guess I'm being naive here, but will userspace still end up with
> something usable on older kernels (ie, kernels that still used the
> various things provided by these headers)? And, even then, are there
> still stable kernels that could possibly have working drivers related to
> these two headers?
> 
> If so I'm fine with providing these headers some additional time. But
> then we should add a "#warning# to these two headers and add a related
> entry to Documentation/feature-removal-schedule.txt). 

I think we should just apply the patches the way you sent them. We are
in the much stricter about binary compatibility than about source level
compatibility, and we already broke any potential user space applications
that might be using these headers by removing the drivers implementing
the kernel side of them, after deciding that they were unused!

Building user space code against new kernel headers to run on old
kernels is not really supported, because that might rely on new interfaces
to be present. The only reason to keep the headers around would be to
keep broken user space code building. I would not expect such code to
still exist for the two header files, and if it does, then giving
it an extra six months before it needs to be fixed is not going to
make much of a difference.

OTOH, if it turns out that a modern distro still contains a package
that relies on these headers, I would advocate putting a minimal
header file with a #warning back into the kernel.

The only reference I could find on the internet to the ioctl commands
that are getting removed is in the FreeBSD "stallion" user space,
and they ditched the driver four years ago:
http://lists.freebsd.org/pipermail/freebsd-questions/2008-April/173526.html

	Arnd
