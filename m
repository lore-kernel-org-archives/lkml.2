Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2FOLTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:19:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27754 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FOLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:19:48 -0400
Date: Fri, 15 Jun 2012 14:19:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Fengguang Wu <wfg@linux.intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@freedesktop.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Subject: Re: automated warning notifications
Message-ID: <20120615111913.GA13539@mwanda>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
 <20120615071222.GZ13539@mwanda>
 <20120615075810.GA13206@localhost>
 <alpine.DEB.2.02.1206150639130.1864@hadrien>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1206150639130.1864@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 15, 2012 at 06:40:51AM -0400, Julia Lawall wrote:
> > > Eventually I think we will want to set up a mailing list for this or
> > > we will start sending duplicate messages.
> >
> > Fair enough. How can we setup the mailing list? Once the list up, it
> > would be trivial for me to send sparse warnings out there.
> 
> I'm not completely sure that a mailing list would completely eliminate
> duplicate messages.  But still, it could be the place for people who are
> interested in seeing such messages to go to, so it seems like a good
> thing.  I would be happy to contribute content :)

Yeah.  That might be interesting.  If you don't know whether a bug
is a false positive or not you could submit it to the list for
people to look at.

I don't know if anyone will actually look at them.  I had been
planning to filter them to a mail box and automatically ignore
anything that was a duplicate.  But it might actually be worth
looking at them as well.  Especially if you email had enough useful
context so I could tell from the message what the bug is.

Probably we could use something like the attached script to print
out the line of code which causes the bug and some other script to
querry git blame and attach the offending commit?

regards,
dan carpenter


--nVMJ2NtxeReIH9PS
Content-Type: application/x-sh
Content-Disposition: attachment; filename="context.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Afunction usage=0A{=0A    echo "Usage $0 <file name> <line>=
 <context>"=0A    exit 1=0A}=0A=0Acode_file=3D$1=0Alineno=3D$2=0Acontext=3D=
$3=0A=0Aif [ "$lineno" =3D "" ] ; then=0A    usage=0Afi=0A=0Aif [ "$context=
" =3D "" ] ; then=0A    context=3D6=0Afi=0A=0Acat -n $code_file | tail -n +=
$(($lineno - (($context + 1) / 2))) | head -n $(($context + 1))=0A
--nVMJ2NtxeReIH9PS--
