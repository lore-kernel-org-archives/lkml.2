Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1LaPBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 10:01:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36844 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753111Ab1LaPBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 10:01:35 -0500
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, mjg@redhat.com,
        gregkh@suse.de, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Sat, 31 Dec 2011 16:01:33 +0100
From: drahemmaps@gmx.net
Message-ID: <20111231150133.280130@gmx.net>
MIME-Version: 1.0
Subject: Re: loading firmware while usermodehelper disabled.
To: torvalds@linux-foundation.org
X-Authenticated: #35928486
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19OiiQ1G0dOWi9bsHNSTLYqQ/93Wxd0lH0T/J8uap
 AgpHj+iUGdtRwDyc3bXQtiKSVQ3p8GSiBRnA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: mkaNbgkMeSEqbcdaT3YhUJR+IGRvb8CP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@...> writes:
> On Fri, Dec 30, 2011 at 3:54 PM, Dave Jones <davej@...> wrote:
> > We're getting a bunch of reports against Fedora 16
> > (still using 3.1) which look like some drivers are trying to
> > load firmware on resume from suspend, while usermodehelper
> > is disabled.
> 
> Ok, buggy drivers. You *must*not* load firmware in your resume path,
> since there is no actual guarantee that any particular device will be
> resumed after the disk that contains the firmware images.
> 
> So it's very simple: drivers that load firmware at resume time are
> buggy. No ifs, buts, or maybes about it.

Or are they?

You see, PCMCIA cards [don't know about the pccard express stuff]
have to deal with a notable exception from this rule since:

pcmcia: improve check for same card in slot after resume
"88b060d6c03fcb9e4d2018b4349954c4242a5c7f"

This patch changed the way how suspend/resume is handled.
On resume, the pcmcia subsystem obviously does not know
if the card has been removed and reinserted, therefore
it does not call the resume method of the driver but
instead goes for "probe" and things go south from there.

[And now for the $64 question, what happens to USB drivers
that are managing devices which are connected to pcmcia
usb host cards?]
-- 
NEU: FreePhone - 0ct/min Handyspartarif mit Geld-zurück-Garantie!		
Jetzt informieren: http://www.gmx.net/de/go/freephone
