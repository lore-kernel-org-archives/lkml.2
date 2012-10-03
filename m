Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab2JCRBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:01:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51145 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965071Ab2JCRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 10:00:43 -0700
X-Google-Sender-Auth: K-7_vWno3y3mWvStlOsB406tOh0
Message-ID: <CA+55aFwpmUPF4MR+rVJ=MOYGseWGN9DvMTivbwxQ4gh_izrryg@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
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

On Wed, Oct 3, 2012 at 9:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway. Attached is a really stupid patch that tries to do the "direct
> firmware load" as suggested by Ivan. It has not been tested very
> extensively at all (but I did test that it loaded the brcmsmac
> firmware images on my laptop so it has the *potential* to work).

Oh, and I stupidly put the new functions next to the builtin firmware
loading function, which means that the patch only works if you have
CONFIG_FW_LOADER enabled.

That's bogus, and the functions should be moved out of that #ifdef,
but I don't think it should hurt testing.

                    Linus
