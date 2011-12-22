Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1LVQSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:18:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1LVQSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:18:40 -0500
Date: Thu, 22 Dec 2011 17:18:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com,
        Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
Message-ID: <20111222161810.GB13554@redhat.com>
References: <4ED43A5C.9000102@gmail.com>
 <20111129114603.GB7299@redhat.com>
 <CADLC3L2QpEtPiBg+yvaxir1LpU6j5YMpDG4g0+ezs06g745zcg@mail.gmail.com>
 <20111220144317.GA6027@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220144317.GA6027@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:43:17PM +0100, Stanislaw Gruszka wrote:
> I just discovered that at least some problems are related with power
> save. After "iwconfig wlanX power off" I have pretty short ping times
> and good throughput, both comparable with vendor driver. But I did not
> check that on all adapters that I have yet.
>
> Looking a bit more at that seem we stop and wake queues several times
> between sending each frame. Looks like that thing need to be optimized
> in mac80211, or some parameters have to be setup properly by rt2x00 ...
> 
> Also rt2800 PCI and SOC have PS disabled by default ...

There is no bug with ping latencies when power save is enabled. Ping
send packet every second, between that we put driver in power save
mode (i.e. tell AP that we are sleeping and it has to buffer frame
to us). When we send ping packet, we wake up and receive packet from
a AP after longer time than in normal operation mode.

I did more testing here and I have one device that works very bad,
no matter if PS is configured or not. It is 

phy6 -> rt2x00_set_chip: Info - Chipset detected - rt: 3071, rf: 0008, rev: 021c.

I'm going to investigate problems with that device, hopefully these are the
same problems that Robert and Andreas have.

Stanislaw
