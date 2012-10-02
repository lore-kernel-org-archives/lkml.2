Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2JBWr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:47:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39686 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2JBWr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121002222333.GA32207@kroah.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Oct 2012 15:47:36 -0700
X-Google-Sender-Auth: HbEVZux__vAS6PJ8xJhlA2roI5s
Message-ID: <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 3:23 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> which went into udev release 187 which I think corresponds to the place
> when people started having problems, right Mauro?

According to what I've seen, people started complaining in 182, not 187.

See for example

  http://patchwork.linuxtv.org/patch/13085/

which is a thread where you were involved too..

See also the arch linux thread:

  https://bbs.archlinux.org/viewtopic.php?id=134012&p=1

And see this email from Kay Sievers that shows that it was all known
about and intentional in the udev camp:

  http://www.spinics.net/lists/netdev/msg185742.html

There's a possible patch suggested here:

  http://lists.freedesktop.org/archives/systemd-devel/2012-August/006357.html

but quite frankly, I am leery of the fact that the udev maintenance
seems to have gone into some "crazy mode" where they have made changes
that were known to be problematic, and are pure and utter stupidity.

Having the module init path load the firmware IS THE SENSIBLE AND
OBVIOUS THING TO DO for many cases. The fact that udev people have
apparently unilaterally decided that it's somehow wrong is scary.

               Linus
