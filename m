Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0K1XrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 18:47:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39949 "EHLO
	localhost6.localdomain6" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840Ab0K1XrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 18:47:05 -0500
Date: Sun, 28 Nov 2010 23:46:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: microcai@fedoraproject.org
Cc: Lisa Milne <lisa@ltmnet.com>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101128234634.461daec4@pyx>
In-Reply-To: <1290961207.13526.31.camel@cai.gentoo>
References: <1290941875.13526.15.camel@cai.gentoo>
	<73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	<1290951770.13526.18.camel@cai.gentoo>
	<AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	<20101129020610.7ea7c79e.lisa@ltmnet.com>
	<1290961207.13526.31.camel@cai.gentoo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sounds like a good idea. Who is in charge of VT system ? Seems no
> one ....

Which bit - lots of people own different parts of it, because there is a
lot of it, and people own different sections of currently ongoing
projects. Plus the X DRM folks own the KMS framebuffers, various authors
own their own low level drivers for each card and so on.

I kind of own the drivers/tty/vt* bits.

I simply don't see how you are going to address the majority of the
worlds languages in kernel space, all the major ones are too complex and
pango is too big and complex to put in kernel as are the needed font
renderers. Most of the needed compositing accelerations are also not
directly exposed in KMS to the console driver as would be needed

Your other problem is mode setting, VESA is on its way out, a lot of
devices today, especially non X86 ones pretty much need X to do any kind
of video management beyond "here is how the firmware console was
configured", and indeed many embedded devices don't have an VT code
enabled at all, just a printk console and possibly ttyprintk, both of
which may well only be talking to the debug ports

Alan
