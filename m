Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2JCUc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:32:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45787 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2JCUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <20121003194819.GA2490@shutemov.name>
References: <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003194819.GA2490@shutemov.name>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 13:32:06 -0700
X-Google-Sender-Auth: fYiD_oNbfApv2El2kWfc6xev_00
Message-ID: <CA+55aFy+AgfVTP=_0n0k2Zq39RVx6ywZpx8FkHvDjsJWGS+RkQ@mail.gmail.com>
Subject: Re: Access files from kernel
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
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

On Wed, Oct 3, 2012 at 12:48 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> AFAIK, accessing files on filesystem form kernel directly was no-go for a
> long time. What's the new rule here?

Oh, we've *always* accessed files from the kernel.

What we don't want is random drivers doing so directly and without a
good abstraction layer, because that just ends up being a total
nightmare.

Still, they've done that too. Ugh. Too many drivers having random
hacks like that.

            Linus
