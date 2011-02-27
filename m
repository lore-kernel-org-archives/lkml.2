Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab1B0Fqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 00:46:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36167 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1B0Fqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 00:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VKK1MbQazuPB5okiIixVN3ect2xn9aB4fNxirsionaInilLWARlkoXBsMsZdgwhEp5
         T6I4fH/38d9spshraEBzS9rxTLBryPCqlAPhP9ahkrB0iVHKl19E4Ar1XXVgOnrXp8tJ
         eQYVFdpldB2PJUi+C6UAEprIl0CxLBTJofcxE=
MIME-Version: 1.0
Date: Sun, 27 Feb 2011 00:44:01 -0500
Message-ID: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
Subject: txqueuelen has wrong units; should be time
From: Albert Cahalan <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(thinking about the bufferbloat problem here)

Setting txqueuelen to some fixed number of packets
seems pretty broken if:

1. a link can vary in speed (802.11 especially)

2. a packet can vary in size (9 KiB jumbograms, etc.)

3. there is other weirdness (PPP compression, etc.)

It really needs to be set to some amount of time,
with the OS accounting for packets in terms of the
time it will take to transmit them. This would need
to account for physical-layer packet headers and
minimum spacing requirements.

I think it could also account for estimated congestion
on the local link, because that effects the rate at which
the queue can empty. An OS can directly observe this
on some types of hardware.

Nanoseconds seems fine; it's unlikely you'd ever want
more than 4.2 seconds (32-bit unsigned) of queue.

I guess there are at least 2 queues of interest, with the
second one being under control of the hardware driver.
Having the kernel split the max time as appropriate for
the hardware seems nicest.
