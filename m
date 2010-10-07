Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0JGTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:25:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54090 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0JGTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=kikd2cr45MUUNckKYVPnN+xDC8OmZ5izLqgi8eBbGybhZ9RI2ZXDjhAI9oiuZoQ+KU
         cxkwMIVrsOVcanvSHGGtpwo3MtzuXXnMPrZMGBZ4/QGYfok6T8d6UsvE7+qZvRT+Bzji
         9nVHNcqubZsjqAjFNsy84nkAs1kVVJOEadId0=
MIME-Version: 1.0
In-Reply-To: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Oct 2010 15:25:34 -0400
X-Google-Sender-Auth: _w0DuoYL6yevvpVCc2musvSy8KQ
Message-ID: <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 14:36, Daniel Walker wrote:
> Many of JTAG debuggers for ARM support DCC protocol over JTAG
> connection, which is very useful to debug hardwares which has no
> serial port. This patch adds DCC serial emulation and the console
> support. System timer based polling method is used for the
> emulation of serial input interrupt handling.

why use serial_core at all ?  seems like you could just use the tty
layer directly.  i did that with drivers/char/bfin_jtag_comm.c.

although, there's the suggestion in the air that my jtag driver could
be converted to the HVC framework to even further simplify things.
but no one thinks it should be serial_core :).
-mike
