Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab0KOSae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:30:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54598 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab0KOSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:30:32 -0500
Message-ID: <4CE17C4E.7010206@kernel.org>
Date: Mon, 15 Nov 2010 10:30:38 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: jaxboe@fusionio.com, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: More XFS resource starvation?
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 15 Nov 2010 10:30:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So apparently I'm having fun tripping over all kinds of bugs lately.
I've seen this a couple of times now on the box in question.  Usually
happens after a few days, or after particularly heavy rsync traffic on
the box.

http://pastebin.osuosl.org/36014

Christoph seemed to think it's a memory exhaustion problem, so I've
included the /proc/meminfo and as you can see there's plenty of memory
around on the system.

Loads have, expectedly, climbed currently around 1250.05 but growing slowly.

Quick overview of the underlying storage:

xfs -> md (raid 0) -+--> P812 hardware raid6 (cciss driver)
                    |
                    +--> P812 hardware raid6 (cciss driver)

This is running on an HP DL380 G7.

I saw this both on an older 2.6.30.10-105.2.23.fc11.x86_64, and
currently on 2.6.34.7-61.fc13.x86_64 (both being Fedora stock kernels)

I have not seen this on a very similar DL380 G6, with the same storage
setup and it is currently running the 2.6.30 kernel from above.

Christoph suggest increasing the nr_request values for each of the
underlying devices, but this didn't seem to change anything
significantly on the system.

Anyone have any ideas on what's going on?

- John 'Warthog9' Hawley
