Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2JDBm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:42:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47298 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2JDBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:42:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNTZmG+zTQNi9mCn9ynsCjkM084TmHKDcYYggtqLfhqNQ@mail.gmail.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <CACVXFVNTZmG+zTQNi9mCn9ynsCjkM084TmHKDcYYggtqLfhqNQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 18:42:34 -0700
X-Google-Sender-Auth: 2PBjB825iGFCPC9LEdXJAFIvlQE
Message-ID: <CA+55aFxJ=Z+c3NxWgOajYD6MOK-7cT=8gfPN9BP_jjhYbs6Z6g@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Ming Lei <ming.lei@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:33 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> Yes, the patch will make firmware cache not working, I would like to fix
> that when I return from one trip next week.
>
> BTW, firmware cache is still needed even direct loading is taken.

I agree 100%, I'd have liked to do the caching for the direct-loading
case too. It's just that the freeing case for that is so intimately
tied to the firmware_buf format which is actually very inconvenient
for direct-loading, that making that happen looked a lot more
involved.

And I was indeed hoping you'd look at it, since you touched the code
last.  "Tag, you're it"

It shouldn't be *too* bad to instead of doing the "vmalloc()" allocate
an array of pages and then using "vmap()" instead in order to read
them (we end up doing the vmap anyway, since the firmware *user* wants
a virtually contiguous buffer), but the code will definitely get a bit
more opaque.

                        Linus
