Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2KUAYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:24:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33432 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2KUAYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:24:40 -0500
Date: Wed, 21 Nov 2012 00:29:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v3] devtmpfs: mount with noexec and nosuid
Message-ID: <20121121002955.1ec7ad39@pyramind.ukuu.org.uk>
In-Reply-To: <CAGXu5jJLRyQCj3dHeuQwvTnn2=qsJ4MsiiQRsuPLzLSzM2SUmA@mail.gmail.com>
References: <20121120215059.GA1859@www.outflux.net>
	<20121121000510.7a3c6673@pyramind.ukuu.org.uk>
	<CAGXu5jJLRyQCj3dHeuQwvTnn2=qsJ4MsiiQRsuPLzLSzM2SUmA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not trying to say it's a magic cure-all. This feature is just for
> trying to build a system that follows security best-practices: nothing

If you want to talk about security practices then please do so rather
than using it as a magic label for cluelessness.

> I don't need a specific example to follow best practices. Any example

Yes you do. You should be able to accurately describe the attack vector,
the bounding constraints and the breach of those constraints.. so your
example will do fine.

> If you want an invented example, how about a uid-0 service (let's say
> listening on dbus) that takes arguments for some command (say "df")
> and let's say it's really badly written, and filters all shell metas
> except ";" so it'll run "df -- $arg" where $arg can't contain any $IFS
> characters, but can lead with a semi-colon, meaning it can run a
> single command but can't control arguments. Let's say there's nothing
> else on the system that just running it will cause a problem, and so a
> second flaw in some other service (or maybe the same one) can write
> files to arbitrary locations, and the only writable and executable
> location in the filesystem tree is /dev (e.g. all other locations are
> either read-only or noexec). So an attacker writes a file to /dev/evil
> and then uses the other flaw to run it.

Which is fixed by using a mount syscall in userspace. Even better that
can be done and deployed on existing systems without a kernel change and
without having to move to a new kernel. From a good practice point of
view you are arguing for the wrong thing - poorer comaptibility, riskier
deployment, more code executed at higher privilege levels.

The *only* case I can see where the feature is useful is enforcing no
exec on /dev/ except for (potentially specific) device nodes. I can do
that today with AppArmour, Smack or SELinux but having a lighter way to
do it might be useful.

Alan

