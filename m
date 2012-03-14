Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab2CNAyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:54:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51464 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928Ab2CNAyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP118s+DuLaATKOq7w=F82GB=8PkwUJDichffXA-Er6Zqvw@mail.gmail.com>
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl>
 <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
 <201203140110.40671.rjw@sisk.pl> <CAPXgP118s+DuLaATKOq7w=F82GB=8PkwUJDichffXA-Er6Zqvw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Mar 2012 17:54:16 -0700
X-Google-Sender-Auth: 7Zoq8jx6NGLkiY3zGwihQcF79Mo
Message-ID: <CA+55aFxq=GWof-ExXjeC2nwUBcGi46SKwcvc2iccfymbbyXbfA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Kay Sievers <kay@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 5:14 PM, Kay Sievers <kay@vrfy.org> wrote:
>
> Yeah it's certainly useful to disable the exec() during suspend calls,
> much more than using the exec() inhibit flag for the firmware loader
> to throw a warning about suspend issues.

Kay, just stop confusing the issue already.

It has *nothing* to do with exec. It has *nothing* to do with
/sbin/hotplug. Stop repeating that stupid mantra. It's totally and
utterly irrelevant.

You can't load firmware while the system is suspended. End of story.
You can't load it using /sbin/hotplug, you can't load it with dbus,
you cannot load it FULL STOP.

The filesystem you'd want to load it from may simply not be ready yet.

This has nothing to do with exec or anything else. It's very simple:
you cannot load firmware while the system isn't yet fully up.
Seriously.

You need to wait to load the firmware until everything is all done,
and things work.

Or you should - preferably - just have preloaded the damn thing.

           Linus
