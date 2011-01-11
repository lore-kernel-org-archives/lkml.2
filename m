Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1AKDlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:41:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1AKDli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:41:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] drivers: char: hvc: add Blackfin JTAG console support
Date: Tue, 11 Jan 2011 04:41:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: linux-serial@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
References: <1294713837-4929-1-git-send-email-vapier@gentoo.org> <AANLkTinnuxvx9+eNvCqjK2GW2XQPn4LjK4WfMj=f20Xw@mail.gmail.com>
In-Reply-To: <AANLkTinnuxvx9+eNvCqjK2GW2XQPn4LjK4WfMj=f20Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101110441.33841.arnd@arndb.de>
X-Provags-ID: V02:K0:g0PPb7s+Aszcu+dmXomgRxrCC8w5rqkDDr1G/rBoIPc
 +fRfSIIY0b2QjjggNPjP57HNpV0tNAiXDZ4nUoWdJgpTQHU+MI
 WkpFtkVtWyyeBGpsAOmctRL1xGUTrIj9dpzadM8c+S3IlkkWqJ
 RAh3bOmGKlYVb/V/JTx4Q4VkvlXP8hIWIN/fQzjUFKLIGL1Uae
 100/aYXfvvuW/CwTUSPeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 January 2011, Mike Frysinger wrote:
> throughput seems to be a bit lower.  the Blackfin JTAG hardware has
> basically a 4 byte fifo that is filled/consumed in a single shot.  and
> the Blackfin can produce much faster than the host can consume.  so
> atm, i have it send out 4 bytes, and the hvc layers take care of
> calling back into me at some point.  if i add a busy loop to run a few
> hundred milliseconds (like HZ/4), it runs much nicer.  but obviously
> doesnt give anyone else time to run.  i cant schedule or anything as
> the write layers are called with a spin_lock_irqsave.  any tips for
> how to speed this up a bit ?  or is it a wash with hvc ?

You could try lowering the hvc MIN_TIMEOUT value. If you want to
change it for blackfin, you could probably make it a configuration
option. However, if it really takes a few milliseconds that you need
to wait between two accesses, MIN_TIMEOUT should already be small
enough.

You should really not need to sleep in your output function, as
the khvcd() timeout logic tries handling this in the best way.
There may be a bug in that logic though (wouldn't be the first one
there), so try to see what the timeouts are when you get into 
this problem.

	Arnd
