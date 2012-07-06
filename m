Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2GFTe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 15:34:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53015 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2GFTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:34:58 -0400
Date: Fri, 6 Jul 2012 20:38:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jukka Ollila <jiiksteri@gmail.com>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, jbeulich@novell.com,
        greg@kroah.com, torvalds@linux-foundation.org
Subject: Regression - /proc/kmsg does not (always) block for 1-byte reads
Message-ID: <20120706203825.20ce3e47@pyramind.ukuu.org.uk>
In-Reply-To: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012 20:45:44 +0300
Jukka Ollila <jiiksteri@gmail.com> wrote:

> Hello,
> 
> A few days ago I filed a kernel regression report concerning a change
> in /proc/kmsg behaviour with short reads:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=44211
> 
> The comments suggest that this is probably intentional, but that it
> would be best make sure that the current semantics wrt short reads are
> as intended.
> 
> The problem appears on a Debian (unstable) system that drains
> /proc/kmsg into a separate fifo read by klogd(8):
> 
> /bin/dd bs=1 if=/proc/kmsg  of=/var/run/klogd/kmsg
> 
> With the recent kernel logging changes this /bin/dd exits immediately,
> as 1-byte reads are shorter than any log message could possibly be and
> read() returns 0. No dd feeding the fifo results in no logging and a
> rather unhappy klogd on the reading end of /var/run/klogd/kmsg.
> 
> I suppose a safe solution is to only do reads that are big enough for
> any single kernel message, but this is still a change that affects
> user space being shipped, so some might find it surprising.
> 
> I don't know what other distros do. Is it just Debian being the odd one out?

If this is observed on an actual standard distro userspace and breaks it
then its a regression and it needs fixing or reverting.

Cc'ing Linus
