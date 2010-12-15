Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0LOB6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:58:51 -0500
Received: from relay3.sgi.com ([192.48.152.1]:51621 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755493Ab0LOB6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:58:50 -0500
Message-Id: <20101215015840.390204279@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-15.10
Date: Tue, 14 Dec 2010 19:58:40 -0600
From: Robin@sgi.com, "Holt <holt"@sgi.com
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC 0/2] Speed large x86_64 system boot by calling calibrate_delay() in parallel.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a 4096 cpu machine, we spend a little more than five minutes of the boot
within calibrate_delay().  By doing this work in parallel, we reduce the
time to one minute.
