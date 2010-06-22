Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0FVQNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:13:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63114 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0FVQNl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 12:13:41 -0400
Date: Tue, 22 Jun 2010 12:13:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: trouble daemon <troubledaemon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26 (LOW
 PRIORITY help request)
Message-ID: <20100622161329.GA14978@phenom.dumpdata.com>
References: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C20E133.012F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ultimately, I was wondering if anyone might be able to take a look at
> my dmesg's that might have any idea as to what feature might be new in
> .26 that could be responsible for the panic. Sadly, it takes about 5
> hours to do a clean run of make-kpkg in debian on these machines, and
> I am not setup for distcc or cross compile on my x64 machine yet, so
> it is a painful experience to recompile over and over to try figure
> out what kernel feature it might be that is causing this.

It looks as the fdc driver is stuck in a loop and the init process never
gets pass this stage.

To see if that is the culprit, find the floppy.ko and rename it to say
floppy.ko.bak. Then recreate the initramfs.

The more worrying is the irqs firring. Try to use the 'irqpoll'
parameter as it suggests.
