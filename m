Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab0FQSvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:51:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34655 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab0FQSvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D1ji06hA4gVIDFB8sFX1VqTFIeYoRFi4EZJY7ZW70HPaNLopMIpCoCNUSirm+aAe4t
         PuxSzPAW21cxiOoc9HLPig4yJ9OcG8OX3AbdGOtixA+uFkZL2fsnNfxnml6NOr4s8eZZ
         vHXS1VL719tD26CzdH7/neO4oly6VleHN7zpQ=
MIME-Version: 1.0
In-Reply-To: <1275425591-8803-13-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
	<1275425591-8803-13-git-send-email-arnd@arndb.de>
Date: Thu, 17 Jun 2010 11:50:57 -0700
X-Google-Sender-Auth: NYCSq608kWsvVgnAtGcymfFrRnA
Message-ID: <AANLkTik7PKE1Ch-15riGMzs9fL-4s_nTXrU2rh0yzq0I@mail.gmail.com>
Subject: Re: [PATCH 12/31] tty: serial - fix tty back references in termios
From: Tony Luck <tony.luck@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of build breaks in linux-next (tag: next-20100617)

drivers/serial/ioc4_serial.c:1750: error: expected statement before ‘)’ token

Would have a similar one for ioc3_serial.c if my .config included it.

On Tue, Jun 1, 2010 at 1:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
> index f164ba4..bd2e9e6 100644
> --- a/drivers/serial/ioc3_serial.c
> +++ b/drivers/serial/ioc3_serial.c
 ...
> -       if (I_IGNPAR(state->port.tty))
> +       if (iflag & IGNPAR))

Can we have matching numbers of "(" and ")" here please.

> diff --git a/drivers/serial/ioc4_serial.c b/drivers/serial/ioc4_serial.c
> index 8ad28fc..2c30023 100644
> --- a/drivers/serial/ioc4_serial.c
> +++ b/drivers/serial/ioc4_serial.c
 ..
.-               if (I_IGNPAR(state->port.tty))
+               if (iflag & IGNPAR))

Same here.

-Tony
