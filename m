Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0EKUW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:22:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61638 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0EKUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=q1SZtMeB6mJyWvov0XIvp2/MbwsXzJB5Cz0sUumJ2u7wTTN3STlPX/rth0HCGwrF7I
         D895SxEwDOQWQ7G8z/G6Ir1p3Yrr3qL0k20jG0NAFEoiTGhYQkKPPIY9dghDRAr70WfQ
         s0O65jMMhcb5bvjP3oHekBK4aGM5PpgIESFi4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
	 <20100511060547.GA9644@core.coreip.homeip.net>
	 <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
	 <20100511062110.GB9644@core.coreip.homeip.net>
	 <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>
	 <20100511063309.GC9644@core.coreip.homeip.net>
	 <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
	 <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
	 <1273608441.15067.1002.camel@calx>
	 <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
Date: Tue, 11 May 2010 23:22:22 +0300
X-Google-Sender-Auth: FHvHCOIXILMs7ifWEwgroTfC9x0
Message-ID: <AANLkTim20ALiZiIVGQZyAye-3kUL_i3aYyoOk-P4Z84k@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:10 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>> Make your own slab cache with the alignment flag set, as Pekka already
>> mentioned.
>
> and like i said, that doesnt sound like a reasonable solution when
> every single SPI driver (over 100 atm) out there is affected

Why do you need to do it in every driver? Why not create a cache of
size cache_line_size()*2 or something in the SPI stack and add a
helper function spi_alloc_whatever_this_is_about() for the drivers to
use?
