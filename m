Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0LQMLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:11:25 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45000 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0LQMLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=apCSl1BSNh1fA3Cv0UkEsfiQ1wIOwdKLifHVCcbdg8dR63n9Rj8IJvIZ1XY+pc6cYJ
         RtNy2l63SM7dLXtEn2QbRoHv0oLQAzYW07meczsfFkz4eGELP2nbap4qZzQKverN8jtv
         +AXv2ROOWlKWuDPyE+i4nR/MO5cn0wb8Dt6x0=
MIME-Version: 1.0
In-Reply-To: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Date: Fri, 17 Dec 2010 13:11:22 +0100
Message-ID: <AANLkTikboaQGMGTVchXyo6tidtq7c33KDRU2puL1youv@mail.gmail.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par,

On Fri, Dec 17, 2010 at 12:20 PM, Par-Gunnar Hjalmdahl
<par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> This is the 3rd patch set for the ST-Ericsson CG2900 connectivity
> controller. The CG2900 is a combo controller supporting GPS, Bluetooth,
> and FM radio. It uses HCI H:4 protocol to combine different functionalities
> on a common transport, where first byte in the data indicates the current
> channel. Channels 1-4 are standardized in the Bluetooth Core specification
> while the other channels are vendor specific.
>
> Compared to 2nd patch set this patch set has the following changes:
>  * UART handling is moved from mfd to bluetooth folder. It now reuses the
>   existing N_HCI line discipline.
>  * mfd creation has been moved from cg2900_core into chip specific files.
>  * All information for each channel, including API functions, exist in each
>   MFD devices, making them independent of each other.
>  * All chip specific information has been moved from cg2900_core into the
>   chip specific files. cg2900_core now only handles registration and
>   connection between transport and chip driver.
>  * Fixes for several review comments including use of existing debug system.

this patchset has only multiplied my confusion.

Not really diving into the details, I'm just trying to understand how
I'd rewrite the TI shared transport using your approach if I had to.
It looks like I'd have to, at least:
 - implement a heavyweight line discipline driver (like cg2900_uart.c)
half duplicating the functionality in yours;
 - implement specific MFD driver.

Actually the reuse of this implementation will be at a level of
statistics error. The only thing to reuse is actually the approach
which I'm not really happy about.

So...

If you are aiming for a generic solution, then why you get more and
more things handled in cg2900-specific code (e. g. packet routing
which is fairly generic)?

If you are solving your particular problems, isn't the change too
dramatic e. g. when it comes to line discipline drivers and baudrate
manipulation?

As of now, I really see no reason why anyone would promote this
solution instead of making something more generic out of ti-st and
reusing it then.

Thanks,
   Vitaly
