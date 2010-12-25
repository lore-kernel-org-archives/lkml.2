Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0LYV2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:28:41 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:41861 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0LYV2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:28:40 -0500
Message-ID: <4D166205.4070205@msgid.tls.msk.ru>
Date: Sun, 26 Dec 2010 00:28:37 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Jaap Crezee <jaap@jcz.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain> <4D14BB36.1030304@msgid.tls.msk.ru> <20101225121407.GA2116@bitwizard.nl> <alpine.DEB.1.10.1012251317420.27193@uplift.swm.pp.se> <4D1633F2.3040109@jcz.nl>
In-Reply-To: <4D1633F2.3040109@jcz.nl>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.12.2010 21:12, Jaap Crezee wrote:
> On 12/25/10 13:19, Mikael Abrahamsson wrote:
>> On Sat, 25 Dec 2010, Rogier Wolff wrote:
>> Read errors will use parity drive and be re-written by the md layer.
> 
> Can you show us *that* code? I don't recall seeing this behaviour....
> Just one read error and "bang". Or does the kernel not report the first
> few read errors and just continues without telling us?
> I don't like that. With a normal disk without raid I would have had some
> log telling me the disk got bad?

The code is in the md driver.

This behavour is here for several years.  If the drive respond in time
ofcourse - if it tries to re-read the problematic sector forever and
ignores other commands during this time it will be kicked off any
array - be it software or hardware.

The logs will be in whatever logfile your kernel messages are logged to.

And yes, the application which reads the "problematic" area is _not_
notfied, since the data gets restored from other driver - if that was
an md array with sufficient redundancy (any non-degraded raid other
than raid0).

/mjt
