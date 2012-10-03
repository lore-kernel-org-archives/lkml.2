Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2JCOoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:44:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40458 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2JCOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 07:44:30 -0700
X-Google-Sender-Auth: BZ7rWJQxjuj3LACHM-rTdMn-d_c
Message-ID: <CA+55aFwDWE0RHuDVwUyCSf5aaEVuKzV1cSiSw-FAEapb59YCxA@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 7:36 AM, Kay Sievers <kay@vrfy.org> wrote:
>
> If that unfortunate module_init() lockup can't be solved properly in
> the kernel

Stop this idiocy.

The kernel doesn't have a lockup problem. udev does.

As even  you admit, it is *udev* that has the whole serialization
issue, and does excessive (and incorrect) serialization between
events. Resulting in the kernel timing out a udev event that takes too
long.

The fact that you then continually try to make this a "kernel issue"
is just disgusting. Talking about the kernel solving it "properly" is
pretty dishonest, when the kernel wasn't the problem in the first
place. The kernel not only does things right, but this all used to
work fine.

                   Linus
