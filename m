Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1CROYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:24:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1CROYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:24:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
Date: Fri, 18 Mar 2011 15:24:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, Karsten Keil <isdn@linux-pingi.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Tilman Schmidt <tilman@imap.cc>,
        stable@kernel.org
References: <4C864143.5090803@xs4all.nl> <201011091115.16351.arnd@arndb.de> <1300398521.16073.60.camel@localhost>
In-Reply-To: <1300398521.16073.60.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181524.33246.arnd@arndb.de>
X-Provags-ID: V02:K0:S/EN/+/QN17hcjoyrNH89WQiZyNZEYrN27YIg6Bk+Ww
 3uQoCrriihDP+QGxCVGRm2joEW70KoDR03HvrWz66LwVg/u0L1
 WIm+zncC4eHyJJCqjpf0JtTX5DabAz92XDo/fqf6eNVKwJT4jN
 Gf49eMWLrdiZ6mtp1J0FOn8I21sIGkfRR6Y5Is+s4WHK6VXxG4
 SIl2NE/l0rCAc6+gb+D3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011, Michael Karcher wrote:
> The same issue happened on our system. Sometimes vboxgetty gets stuck in
> state D on a debian stable system (2.6.32). I just applied your patch to
> that kernel and hope the problem went away. Please remind me to report
> back in one to two weeks if I didn't already report whether the hangs
> are fixed. Is something except for a test on a productive system missing
> to get this fix into 32-stable?

Thanks for the report. You are talking about this patch, right?

bc10f96757 "isdn: avoid calling tty_ldisc_flush() in atomic context"

    Remove the call to tty_ldisc_flush() from the RESULT_NO_CARRIER
    branch of isdn_tty_modem_result(), as already proposed in commit
    00409bb045887ec5e7b9e351bc080c38ab6bfd33.
    This avoids a "sleeping function called from invalid context" BUG
    when the hardware driver calls the statcallb() callback with
    command==ISDN_STAT_DHUP in atomic context, which in turn calls
    isdn_tty_modem_result(RESULT_NO_CARRIER, ~), and from there,
    tty_ldisc_flush() which may sleep.
    
    Signed-off-by: Tilman Schmidt <tilman@imap.cc>
    Signed-off-by: David S. Miller <davem@davemloft.net>

	Arnd
