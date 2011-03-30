Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256Ab1C3VUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:20:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36803 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964850Ab1C3VUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:20:13 -0400
Date: Wed, 30 Mar 2011 23:19:39 +0200
From: Florian Mickler <florian@mickler.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        "Lee, Chun-Yi" <jlee@novell.com>
Subject: Re: [PATCH] acer-wmi: does not set persistence state by
 rfkill_init_sw_state
Message-ID: <20110330231939.70ed40ac@schatten.dmk.lab>
In-Reply-To: <1301516552.3791.5.camel@jlt3.sipsolutions.net>
References: <1301516277-1752-1-git-send-email-florian@mickler.org>
	<1301516552.3791.5.camel@jlt3.sipsolutions.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 22:22:32 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2011-03-30 at 22:17 +0200, Florian Mickler wrote:
> > From: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> > 
> > Acer BIOS keeps devices state when system reboot, but reset to default
> > device states (Wlan on, Bluetooth off, wwan on) if system cold boot.
> > That means BIOS's initial state is not always real persistence.
> > 
> > So, removed rfkill_init_sw_state because it sets initial state to
> > persistence then replicate to other new killswitch when rfkill-input
> > enabled.
> > After removed it, acer-wmi set initial soft-block state after rfkill
> > register, and doesn't allow set_block until rfkill initial finished.
> > 
> > Reference: bko#31002
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=31002
> > 
> > Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> > Cc: Matthew Garrett <mjg@redhat.com>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
> > Cc: Corentin Chary <corentincj@iksaif.net>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > Tested-by: OldÅich JedliÄka <oldium.pro@seznam.cz>
> 
> Your mailer messed up the character set, you're advertising
> Content-Type: text/plain; charset=UTF-8
> and then here putting the byte sequence
> \xc3\x85\xc2\x99
> instead of
> \xc5\x99
> 
> for "ř".
> 
> johannes
> 
Dang. That was vim+xterm or git-send-email. 

I did 

git-send-email sha1^..sha1 --to stable --cc lkml --annotate 

and then moved the CC: Old*ich Jedli*ka line via yy and p to the bottom
and changed it to Tested-by:, and added my Signed-off-by: . 

I don't think I can easily fix this up on my side as my xterm sadly 
has some issues with utf8. 
I don't know what's up with that. Maybe font?

Any tipps?
Flo
