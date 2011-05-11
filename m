Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1EKPgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:36:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51013 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1EKPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:36:14 -0400
Message-ID: <F0F0851DD515419B962AB1646D333CB1@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton \(commit_signer:1/4=25%\)" <akpm@linux-foundation.org>,
        "Randy Dunlap \(commit_signer:1/4=25%\)" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com><1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com><034A6447E0D54737B5CEE009A4D20B37@subhasishg><20110509144610.6b4f7090@lxorguk.ukuu.org.uk><3A9C5CD56396439DBF825BB4E5779DB9@subhasishg><20110509145534.2677dfa1@lxorguk.ukuu.org.uk><F0818DA1343E4FF1B3096048359CCC4C@subhasishg> <20110510143243.3e6f4050@lxorguk.ukuu.org.uk>
In-Reply-To: <20110510143243.3e6f4050@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Date: Wed, 11 May 2011 12:31:01 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Trace all looks fine. I can't see anything else taking the lock so you'll
> need to do a bit more debugging and find out why the spin lock change
> makes the difference and what the real root cause is.

We do not support Modem control signals. So, I use -clocal with stty,
but I observe that still enable_ms and get_mctrl handlers get called.
Is that normal, how can I disable these functions from getting called.

Actually, this same driver works perfectly with 2.6.33 kernel.
With this Kernel I do not observe that these handlers getting called.
So, basically the code path is different.

Further, I only use the port->lock to disable interrupts, so its never 
possible that
while interrupts are disabled by my driver, the TTY is executing anything.

There is another lock in the MFD driver, but that only uses spin_lock/unlock
variant. 

