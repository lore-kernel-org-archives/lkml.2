Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2GPRAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:00:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35951 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GPRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:00:14 -0400
Date: Mon, 16 Jul 2012 18:01:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@amd64.org>
Cc: david@lang.hm, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration
 for distro issues
Message-ID: <20120716180157.5f2d9e93@pyramind.ukuu.org.uk>
In-Reply-To: <20120716082418.GC24327@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<1342212885.25704.4.camel@lade.trondhjem.org>
	<CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
	<20120714103716.GD26559@liondog.tnic>
	<CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
	<20120715101434.GA18144@aftab.osrc.amd.com>
	<CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
	<20120715211848.GA21167@aftab.osrc.amd.com>
	<20120715214819.GA1990@moon>
	<alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm>
	<20120716082418.GC24327@aftab.osrc.amd.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Select the profile and then fixup the config the normal way.
> 
> If what the admin wants is incompatible with the profile, admin doesn't
> select the profile.

Thats ugly - "distro except..." is a standard thing you ask users to do
for debugging.

However providing you separate the initial profile from the later tools
it simply becomes 

make distroconfig
	[cp /etc/system-kconfig(.$ARCH?) .config
	 make oldconfig]

make menuconfig (if you want to customise)

In addition the make oldconfig means you can ship a deliberately
incomplete distroconfig and get the user asked some bits.

make 


