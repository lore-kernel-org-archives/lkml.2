Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2KERyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:54:40 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39909 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2KERyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:54:38 -0500
Date: Mon, 5 Nov 2012 17:59:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
Message-ID: <20121105175937.26f31d2a@pyramind.ukuu.org.uk>
In-Reply-To: <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
References: <50899507.1040900@oracle.com>
	<20121026143754.50277bd8@pyramind.ukuu.org.uk>
	<CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012 12:26:43 -0500
Sasha Levin <levinsasha928@gmail.com> wrote:

> Ping? Should I bisect it?
> 
> On Fri, Oct 26, 2012 at 9:37 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Thu, 25 Oct 2012 15:37:43 -0400
> > Sasha Levin <sasha.levin@oracle.com> wrote:
> >
> >> Hi all,
> >>
> >> While fuzzing with trinity inside a KVM tools (lkvm) guest running latest -next kernel,
> >> I've stumbled on the following spew:
> >
> > Looks real enough but its not a tty/vt layer spew. This is all coming out
> > of the core framebuffer code which doesn't seem to be able to decide what
> > the locking rules at the invocation of fb_notifier_call_chain are.
> >
> > It might need some console layer tweaking to provide 'register console
> > and I already hold the locks' or similar but that notifier needs some
> > kind of sanity applying as well.
> >
> > Cc'ing the fbdev folks

I've cc'd the framebuffer folks. I can see why its occurring but I have
no idea how they intend to fix it and I've not seen any replies.

Sorry but I've got enough other things on my plate right now without
trying to deal with the locking brain damage that the fbdev layer is.

As far as I can tell the actual bug proper is years old.

Alan

