Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab0KRQwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:52:18 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58082 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759930Ab0KRQwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=u29a6I4y+Zuoo5dSIgiSpO70fRCmpkTiD6UaPEGae2KMrzaUUwhjZQ5m0nQ5EnKrV+
         l7JBN5FR9FH6EYmbtzDsnSQlMvcxXuM+Opv1L8x7E4OzQlb/RZSOrOcDpJJrO3VDuz+m
         /PPEutYD0eGA+IPOf5FJPPEMSbdGOqax2ei3U=
MIME-Version: 1.0
In-Reply-To: <20101118113441.74fcdc21@lxorguk.ukuu.org.uk>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com> <20101118113441.74fcdc21@lxorguk.ukuu.org.uk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 08:51:46 -0800
X-Google-Sender-Auth: 5jwVdavNq2AKBF-nbbvziuL64sE
Message-ID: <AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 3:34 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I'd like to see hardware bring up at companies being done with Linux.
>
> I know several companies where it is sometimes used.
>
>> with this though. For starters hardware teams typically want to get
>> hardware brought up as fast as possible to be able to sell chipsets.
>> Its always a race. Proper Linux upstream support will get there but
>> depending on the company this may mean this gets done after the
>> proprietary driver approach is done first or simply until you have a
>> big enough customer to justify it.
>
> I've seen the kind of code written to "get it up as fast as possible" and
> also to do validation. It's the sort of code that has to be written
> anyway, and which contains a multitude of fascinating stuff which doesn't
> ever want to go near upstream.

:)

>> everything else can be independent code. For ath9k in particular this
>> means we keep ath9k_hw shared between our Operating Systems and that's
>> it. In addition to this I believe opening up the common drivers for
>
> The Linux copy needs to be GPL,

GPL-Compatible you mean, right. I mean we have ath9k_hw with
permissive licensed files.

> but if you own every line of it then you
> can relicense it. In fact we have examples of big bits of code that are
> not Linux only - eg the ACPI stack which are managed in a non entirely
> unrelated way.

Right, which is why we worked on the permissive license approach to
help OpenBSD back in the day with ath5k.

>> Can Linux help in any way? What if we used staging for a common driver
>> architecture for different OSes?
>
> It's generally gone pear shaped in the past, although tools like spatch
> are more modern than many of those attempts.
>
> There is another way to do it which is instead of writing a glue layer
> for Linux write to the general Linux interfaces which have the virtue of
> being very simple for the most part, and keep the glue layer for the
> other obscure environments where you are doing the stack ?

Not sure I got this last part can you clarify a bit ? One of the ideas
I had was to make the OS agnostic stuff be defined by the Linux APIs
and have the kmalloc() etc map to whatever OS call. While a good idea,
the biggest hurdle was the difference in arguments required, and any
new Linux API change would break the OS wrappers until updated
respectively.

  Luis
