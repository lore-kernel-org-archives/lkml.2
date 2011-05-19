Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab1ESPGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:06:31 -0400
Received: from mail.avalus.com ([89.16.176.221]:43654 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab1ESPGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:06:30 -0400
Date: Thu, 19 May 2011 16:06:27 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: linux-kernel@vger.kernel.org
cc: Alex Bligh <alex@alex.org.uk>
Subject: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <10C5890F8F477E959B993BFA@nimrod.local>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am doing some work on making REQ_FLUSH and REQ_FUA work with block devices
and have some patches that make them perform as expected with nbd if
an nbd device is mounted (e.g. -t ext3, -odata-journal,barriers=1), and
I see the relevant REQ_FLUSH and REQ_FUA appearing much as expected.

However, if I do a straight dd to the device (which generates an open()
and a close()), I see no barrier activity at all (i.e. no REQ_FLUSH and
no REQ_FUA). It is surprising to me that a close() on a raw device does
not generate a REQ_FLUSH. I cannot imagine it is a performance overhead.

I would have thought this would useful anyway (if I've written
to a raw device I'd rather expect it to hit it when I do the close()),
but my specific application is ensuring cache coherency on live migrate
of virtual servers: if migrating from node A to node B, then when the
hypervisor closes the block device on node A, I want to be sure that any
locally cached write data is written to the remote disk before it
unfreezes node B.

Should a close() of a dirty block device result in a REQ_FLUSH?

-- 
Alex Bligh
