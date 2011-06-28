Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1F1IJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:09:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57250 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab1F1IGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nCqJyprXh+QbfKe6UQlorQ62VVY3f3G178pBXWBLvCsfwwjhy9e+2aNdyPBWdy6V28
         ayAth64lHS6/kie5UsxJhzDlzSZ4mW5hPh+t0BpDtivGS6bWa7RrcO6Mmw/mPvyBt5nu
         VTkiTtHbM5otBBMqQl1g0TNt5K9hUWr3SYta4=
MIME-Version: 1.0
In-Reply-To: <1309211120-2803-3-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<1309211120-2803-3-git-send-email-arnd@arndb.de>
Date: Tue, 28 Jun 2011 10:06:40 +0200
Message-ID: <BANLkTimDo7x5MmnNKoopLZNM7RBeNp=Fsg@mail.gmail.com>
Subject: Re: [PATCH 2/7] serial/8250: move alchemy I/O handler to platform code
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Jun 27, 2011 at 11:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Only one platform ever sets the UPIO_AU iotype, so it's
> cleaner to define the handlers in the code that actually
> requires it, rather than building the same logic into
> every 8250 driver.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-serial@vger.kernel.org
> ---
>  arch/mips/alchemy/common/platform.c |   50 ++++++++++++++++++++++++++++++
>  drivers/tty/serial/8250.c           |   58 -----------------------------------
>  2 files changed, 50 insertions(+), 58 deletions(-)

This breaks serial console on all my Alchemy test system.  I'll try to
figure out why.

Manuel
