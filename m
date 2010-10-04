Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0JDIht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:37:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0JDIhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:37:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [RFC] Add IO primitives for Wishbone bus
Date: Mon, 4 Oct 2010 10:37:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1286178037-17337-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1286178037-17337-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041037.43477.arnd@arndb.de>
X-Provags-ID: V02:K0:ErNSD1pD8ByLB1IZ9tLkJk22Yf9WMbaYgMYeDEf7ee7
 uUAKuXMBQ6r/9NbDQA3Jj2C6uOiWLUl8enCQmB9u59945EQ5hv
 gdwTOsEt7m/xT4/aOG+lQ6I3IjXBX0RmUPe0t3Ica51L1t11Y6
 rssLUhdTHQcl2AG/94gt4TIQc0dS/KEFwtis6kv76cvx+xXccG
 sqZDPA9wMxPkT/2oNpjig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 October 2010 09:40:37 Jonas Bonn wrote:
> Is this an acceptable solution or is there another way that would be
> better?  The problem at hand is how best to write a driver for a device
> when the device has the same endianess as the CPU and that endianess is
> arbitrary... for soft cores (OpenRISC in my case), this is a relevant problem,
> as the device endianess is determined along with the CPU core endianess
> at synthesis time...

Looks good in principle, the only possible problem I can see is if you
have both little-endian and big-endian wishbone devices in the same
system, which I assume could happen at some point.

If you want to be able to handle that cleanly, you should pass the device
into the accessor function as well.

It would also be good to provide a matching wb_iomap() function that
returns an iomem token you can use here (see pci_iomap).

A more complex implementation would detect the endianess at wb_iomap
time and return a token that encodes the endianess, which the regular
ioread/iowrite multiplexors can handle then. You probably don't need
to go that far, unless you expect wishbone to become ubiquitous in
the near future.

	Arnd
