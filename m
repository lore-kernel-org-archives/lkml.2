Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1E0Nx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:53:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1E0NxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:53:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Date: Fri, 27 May 2011 15:53:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Andreas Bombe <aeb@debian.org>, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, greg@kroah.com, jirislaby@gmail.com
References: <20110527004104.GB4369@amos.fritz.box> <1306498305-5486-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1306498305-5486-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271553.18132.arnd@arndb.de>
X-Provags-ID: V02:K0:Nku5PYhSjWhS9TDHo8JLw1OXWFRaj2HG1kdZCubPJXB
 bHvTX1nvMwC30Zt2mwsryW/nIph9Rh6pT8+lnr4yZsfdgPbI+f
 BhumgeKQtmIT5v2klKXTspLoXB5beiFRPtl4O5w/bkavlCYmmq
 egBh6lMq717zJBQtdpJz6/6T68KWnhx2uHBDehm9h9PxgKTfVY
 41ubjkjtnn2okPwJO4/3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 May 2011, Jiri Slaby wrote:
> Actually the best would be to get rid of tty_lock completely. Here I
> have a patch removing tty_lock from wait_until_sent path. I've been
> using a kernel with the patch applied for about month without any
> problems. But I have only 8250-based serial.

I agree that this would be the best option. The only reason I had
for holding the tty_lock in wait_until_sent is that it the BKL
has been held there tradiditonally. I could not find anything that
would break without holding it, but I also didn't look very hard.

	Arnd
