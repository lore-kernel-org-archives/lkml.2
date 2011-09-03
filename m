Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1ICK05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 06:26:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41093 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753611Ab1ICK0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 06:26:54 -0400
Date: Sat, 3 Sep 2011 11:25:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Bernie Thompson <bernie@plugable.com>,
        Martin Decky <martin@decky.cz>
Subject: Re: [PATCH 2/2] vt: dirty hack
Message-ID: <20110903112542.5d3cbfcc@lxorguk.ukuu.org.uk>
In-Reply-To: <1315013361-3191-3-git-send-email-FlorianSchandinat@gmx.de>
References: <1315013361-3191-1-git-send-email-FlorianSchandinat@gmx.de>
	<1315013361-3191-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Sep 2011 01:29:21 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

All of the vt stuff wants doing properly not as hacks.

I think the fundamental change you need is to instroduce some sort of
vc->group pointer and vc group object that holds all the globals in the
vt layer for each group (ie move fg_console, console_blanked etc).

That can be done in steps, and once done you can then start to use
vc->group-> within the fbcon driver and possibly also have a per fb
group data attached to vc->group->fb or similar.

Hacks are fine for early prototyping but doing it right means thinking
about the data structures you ultimately need so that existing systems
work, multi-monitor continues to work and you can do proper multi-console
stuff.

I'm all for it happening done right, and some things like being able to
attach an fb console to arbitary GEM objects would allow very nice
integration of the console into things like Wayland.

Alan
