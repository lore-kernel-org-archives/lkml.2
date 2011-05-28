Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1E1XRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:17:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39420 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1E1XRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=8b0ApzZ7v82tUE8-XBeScZEtzDw@mail.gmail.com>
References: <BANLkTi=8b0ApzZ7v82tUE8-XBeScZEtzDw@mail.gmail.com>
Date: Sat, 28 May 2011 19:17:52 -0400
Message-ID: <BANLkTikmG5Me5vfja=6geYg7SW=k2KZxiA@mail.gmail.com>
Subject: Re: [RFC] sdhci: timeouts
From: Charles Hannum <root@ihack.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 19:09, Charles Hannum <root@ihack.net> wrote:
> 4) Ultimately I found that some SDHC cards just seem to take a good
> long time to respond.  I ended up increasing the write timeout to 1s
> and I've encountered 0 problems since then.  Since this is only an
> error condition, and therefore hardly of any performance concerns, I
> suggest it may be a good idea to do this in general.  See attached
> patch sdhci-timeout-limit.diff

BTW, I should mention that, with a TMCLK of 33000 (very common,
because it's just the PCI bus clock), increasing the limit from 300000
to 1000000 us actually increases the “counter” value by exactly 1
(from 11 to 12).  This is probably why the older controller-specific
hack of simply incrementing the counter worked.
