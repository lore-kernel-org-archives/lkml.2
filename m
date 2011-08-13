Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1HMKXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 06:23:44 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:57344 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1HMKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 06:23:43 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Aug 2011 06:23:42 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4E464DF0.7030401@billauer.co.il>
Date: Sat, 13 Aug 2011 13:12:00 +0300
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: LKML <linux-kernel@vger.kernel.org>
Subject: Microblaze, DMA and cache: Lack of sync functions?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Before I make a needless hack, please correct me if I'm wrong: in 
arch/microblaze/kernel/dma.c, the sync_single_for_cpu, 
sync_single_for_device and friends are not set in the dma_direct_ops 
structure (and not implemented), so calls from drivers to the 
corresponding functions will do nothing. Since the Microblaze cache 
doesn't update automatically on DMA operations, this looks like a bug to 
me: The driver thinks the cache has been flushed or updated, but it 
actually hasn't.


Map and unmap methods are indeed implemented and registered, and they 
both call an internal function to sync the cache. So why are there no 
sync functions?

To hack or not to hack?

   Eli

-- 
Web: http://www.billauer.co.il

