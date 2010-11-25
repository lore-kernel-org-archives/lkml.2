Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0KYXj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 18:39:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60484 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0KYXjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 18:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YmlSWPTWKPe2FJ85EojDeBTwUXda9vSoOH9Qax27fZsgT1eVCk8QEpd/AibiGdXVvw
         nJkRZFZdxJGjIdjK6pNBmYH2s4wcATT077BDtKYAQIOh58jOd81H0lMU7fpeOquZI/Ga
         I7yY/6q5bDNS7gbastsF/rX4oXQvGWXh20NrI=
MIME-Version: 1.0
In-Reply-To: <20101125225659.GA13807@build.ihdev.net>
References: <1290642894-4577-1-git-send-email-jslaby@suse.cz>
	<20101125225659.GA13807@build.ihdev.net>
Date: Fri, 26 Nov 2010 10:39:23 +1100
Message-ID: <AANLkTikBivOKSGUc42Xhct5oGyQBUAFs10K1JJPfSiR+@mail.gmail.com>
Subject: Re: [PATCH 1/1] NET: wan/x25_asy, move lapb_unregister to x25_asy_close_tty
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Sergey Lapin <slapin@ossfans.org>
Cc: Jiri Slaby <jslaby@suse.cz>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Mikhail Ulyanov <ulyanov.mikhail@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like some more X.25 users. Not sure on your usage, but I should point out:
https://patchwork.kernel.org/patch/332981/
X.25 protocol needs to have the big kernel lock removed so it can stay
around in the future.
I have been working through them, but there are still some of the more
complex ones remaining.

The test setups I am using are:
Sockets<->X25<->x25loop<->X25<->Sockets
Sockets<->X25<->xotd<->network<->xotd<->X25<->Sockets
and I know some users have:
Sockets<->X25<->xotd<->network<->CiscoXOT<->devices.

Where x25loop is a userspace tun device which shuffles the LCIs, does
some basic call handling and loops the calls back into kernel X25.
xotd is a basic implementation of the X25 over TCP RFC.

Are you using something like this?
Sockets<->X25<->lapb<->x25_async<->.....

If you are using X25 I would be interested to see how your setup goes
with the X25 BKL cleanup work, and if anyone wanted to help with the
remaining BKLs :)


On Fri, Nov 26, 2010 at 9:56 AM, Sergey Lapin <slapin@ossfans.org> wrote:
> On Thu, Nov 25, 2010 at 12:54:54AM +0100, Jiri Slaby wrote:
>> We register lapb when tty is created, but unregister it only when the
>> device is UP. So move the lapb_unregister to x25_asy_close_tty after
>> the device is down.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Reported-by: Sergey Lapin <slapin@ossfans.org>
>> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Tested-by: Sergey Lapin <slapin@ossfans.org>
> Tested-by: Mikhail Ulyanov <ulyanov.mikhail@gmail.com>
>
