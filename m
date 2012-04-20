Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2DTKF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:05:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab2DTKFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:05:24 -0400
Date: Fri, 20 Apr 2012 12:05:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Add support for G27 LEDs
In-Reply-To: <2702029527a38f9e28882007b36eaf73.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1204201156300.29484@pobox.suse.cz>
References: <alpine.LNX.2.00.1204131458290.16373@pobox.suse.cz>    <1334732588-9351-1-git-send-email-simon@mungewell.org>    <alpine.LNX.2.00.1204181320180.16373@pobox.suse.cz> <2702029527a38f9e28882007b36eaf73.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, simon@mungewell.org wrote:

> > Putting the whole err: label outside the outer for cycle would make the
> > whole thing much more readable (and would save you the break). Could you
> > please redo this?
> 
> The 'break' is actually not needed as 'j' has reached maximum value and
> the outer for loop would be at completion. 

Ah, right, I have even missed this fact, that you are using the same index 
in the inner loop as in the outter loop.

Quite unreadable indeed :)

> I put the 'break' there just to highlight this fact.
> 
> Maybe just a comment would be OK, such as 'on error fall though to driver
> completion'.
> 
> The reason I'd like this code here is that it seems traditional to output
> the following 'hid_info' line once the driver is fully active.
> 
> >>  	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by
> >> Simon Wood <simon@mungewell.org>\n");
> 
> Moving the 'err:' code would have to:
> 1). Jump back to hit this hid_info line
> 2). Duplicate the hid_info line
> 3). Have err code called as a function

I am not getting it. Why can't you do just something like


	for ( .... ) {
		/* outter loop */
		if (error) {
			for ( ... ) {
				/* inner loop */
			}
			goto out;
		}
	}
out:
	hid_info(....);
	return;

-- 
Jiri Kosina
SUSE Labs
