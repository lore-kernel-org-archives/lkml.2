Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2DBAFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 20:05:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38489 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2DBAFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 20:05:49 -0400
Date: Mon, 2 Apr 2012 01:08:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120402010819.76d31790@pyramind.ukuu.org.uk>
In-Reply-To: <4F78D0BA.9040709@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by>
	<4F78D0BA.9040709@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Apr 2012 15:03:38 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 04/01/2012 05:57 AM, Alexey Dobriyan wrote:
> > 
> > * /proc/self/fd is unreliable:
> >   proc may be unconfigured or not mounted at expected place.

Equally someone could be ptracing your process and changing the answers.
Both are "do stupid stuff, get stupid answers" cases. Why do we care ???
Lots of other stuff breaks in this case so nobody will be doing it for
good reasons

> >   Looking at /proc/self/fd requires opening directory

Which is very efficient

> >   which may not be available due to malicious rlimit drop or ENOMEM situations.
> >   Not opening directory is equivalent to dumb close(2) loop except slower.

If I've rlimited you to no file handles then you already lost whichever
approach you use. Just abort. Trying to do clever stuff in security
sensitive situations via codepaths that inevitably don't get tested when
you've apparently got a malicious executor is dumb.

> (if someone can set an rlimit they can also force an abort) or revert to
> the slow path.

Or have set a CPU limit or memory limit or more.

Alan
