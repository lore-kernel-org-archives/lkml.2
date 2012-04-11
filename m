Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab2DKAVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:21:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54592 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab2DKAVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:21:02 -0400
X-Sasl-enc: RpWxERs5WTbyWmDZmW0gd5/xCRaipd+X2SaCAuOJuKGT 1334103660
Date: Tue, 10 Apr 2012 21:20:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jan Kara <jack@suse.cz>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Dave Chinner <david@fromorbit.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.38->3.0+
Message-ID: <20120411002057.GC7792@khazad-dum.debian.net>
References: <4F75E46E.2000503@msgid.tls.msk.ru>
 <20120405232913.GA6640@quack.suse.cz>
 <4F7E74F4.90604@msgid.tls.msk.ru>
 <20120410022628.GN18323@dastard>
 <4F83CC86.2010805@msgid.tls.msk.ru>
 <20120410151326.GA4936@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410151326.GA4936@quack.suse.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012, Jan Kara wrote:
> >   2.6.38:
> >   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
> >   100+0 records in
> >   100+0 records out
> >   104857600 bytes (105 MB) copied, 1.73126 s, 60.6 MB/s
> > 
> >   3.0:
> >   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
> >   100+0 records in
> >   100+0 records out
> >   104857600 bytes (105 MB) copied, 29.4508 s, 3.6 MB/s
> > 
> > That's about 20 times difference on direct read from the
> > same - idle - device!!

You might want to investigate the cpu-idle stuff (especially intel-idle if
it is an Intel box with a recent processor: force the box to use acpi-idle
instead) and the cpufreq stuff (try the test with the box with the
"performance" governor).

> Anyway, the most likely cause seems to be some driver issue (which would
> also explain why you can see it only on one machine). I'd also compare very
> closely config files of the two kernels if there isn't some unexpected
> difference...

Indeed.  But that's such a massive performance drop, I'd also be comparing
the boot log messages of both kernels with diff, and also the lspci -vvv
output...  just in case :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
