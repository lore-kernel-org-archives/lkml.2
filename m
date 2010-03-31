Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab0CaAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:25:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57689 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757641Ab0CaAZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 20:25:52 -0400
X-Sasl-enc: Ju5KNaOoy6AVADSpkHfhoqRsTJHILpLgLfyXPf1D6LbM 1269995151
Date: Tue, 30 Mar 2010 21:25:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Pilarski <Thomas.Pilarski@arcor.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
Message-ID: <20100331002549.GB9925@khazad-dum.debian.net>
References: <bug-12309-14043@http.bugzilla.kernel.org/>
 <201003162357.o2GNvkNF024562@demeter.kernel.org>
 <1269935094.2481.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269935094.2481.23.camel@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Thomas Pilarski wrote:
> This problem is enormous increased, while the ultra bay disc is acceded
> with udma2 instead of udma6 (caused by another bug), 

There is a thinkpad BIOS bug that could cause that: it will not signal a
80-wire cable when you hot-add an HD on a PATA ultrabay.  Exists at least on
all T4x, including the T43.

The fix is to whitelist these thinkpads for high-speed UDMA even on 40-wire
cables.  The workaround is to add a kernel command line parameter (I forget
which).

Does that match your udma2 instead of udma6 problem?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
