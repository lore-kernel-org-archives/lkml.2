Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1CYJ4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:56:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58995 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753304Ab1CYJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:56:34 -0400
Date: Fri, 25 Mar 2011 09:56:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>,
        "jozef.kralik@eset.sk" <jozef.kralik@eset.sk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/1] fsnotify,fanotify: adding flag for execution
Message-ID: <20110325095624.0524d975@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=yQ=n8xNC2GdXic_O6yQYD0r0D8QZwb2CqSk4r@mail.gmail.com>
References: <417044.386125298-sendEmail@jojo-hp-compaq-8100-elite-cmt-pc>
	<1300980654.2398.3.camel@localhost.localdomain>
	<AANLkTi=yQ=n8xNC2GdXic_O6yQYD0r0D8QZwb2CqSk4r@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have indeed historically had those kinds of bugs. For example,
> having 'noexec' disable execve() on files, but *not* disabling using
> them as LD_PRELOAD=xyz things where they aren't the target of an
> execve(), but the code in them is run anyway (thanks to just an
> executable mmap(), or even a "read()" into a data segment that is
> executable)

Actually there is a difference

> So I don't know what makes "executed" different from "read". Because
> at some point we really cannot tell the difference.

And this isn't quite true

> The one special thing about execve() is that it can execute something
> even when it's not readable. But people who have depended on that as a
> security feature have always been disappointed (ie just execve it and
> then use ptrace to read the contents of the file _anyway_). So once

And ptrace covers this

The specific case that has always been the one Unix has cared about is
'exec but no read bit', and execve() covers that correctly, including
stopping it being dumpable thus blocking ptrace.

Various standard Unix tricks rely upon this behaviour, notably the cd
into a directory whose name you can't determine to access "protected" by
writable stuff. All of the latter is really about suid apps though.

Alan
