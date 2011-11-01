Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1KAGBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:01:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53924 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750778Ab1KAGBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:01:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+J/3Zfm3SJN4aMU1dFcUhPH8w8mBGhiapFC7CayV
	UJw9KQ0A51ox5u
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
From: Mike Galbraith <efault@gmx.de>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4EAEF004.8070005@genband.com>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
	 <20111030212644.GA7106@khazad-dum.debian.net>
	 <4EAEF004.8070005@genband.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 07:01:46 +0100
Message-ID: <1320127306.6305.82.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 12:59 -0600, Chris Friesen wrote:

> I created a tiny cpu burner program that just busy-loops.  Running two 
> instances on my system they were always scheduled on separate physical 
> cpus regardless of the values in sched_mc_power_savings or 
> sched_smt_power_savings.

A wakeup driven load using sync wakeup hint will wake to siblings of the
same core if there's too not too much imbalance though.  Whether that's
good or bad.. depends.

If you turn SD_SHARE_PKG_RESOURCES off in the sibling sched domain,
wakees should be awakened CPU affine in sync hint case, or on separate
cores in no sync hint case.  They are here anyway.

	-Mike 

