Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2KEUK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:10:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40061 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2KEUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:10:22 -0500
Date: Mon, 5 Nov 2012 20:15:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
Message-ID: <20121105201507.79fe47d7@pyramind.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1211051106590.1709@eggly.anvils>
References: <50899507.1040900@oracle.com>
	<20121026143754.50277bd8@pyramind.ukuu.org.uk>
	<CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
	<20121105175937.26f31d2a@pyramind.ukuu.org.uk>
	<5097FEA9.2090603@oracle.com>
	<alpine.LNX.2.00.1211051106590.1709@eggly.anvils>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The fbdev potential for deadlock may be years old, but the warning
> (and consequent disabling of lockdep from that point on - making it
> useless to everybody else in need of it) is new, and comes from the
> commit below in linux-next.
> 
> I revert it in my own testing: if there is no quick fix to the
> fbdev issue on the way, Daniel, please revert it from your tree.

If you revert it you swap it for a different deadlock - and one that
happens more often I would expect. Not very useful.

I'm hoping the framebuffer maintainer will bother to respond to this
because that's the only way it can be sorted out.

Alan
