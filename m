Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0HYSfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:35:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40776 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0HYSfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:user-agent:mime-version
         :content-type:content-transfer-encoding:x-priority:importance;
        b=V5qiBPWpS9ZJboFHcXwUrSLPfEOilBkNxyXrBk7x1RNlEIGOQ62uRkIMTW2sS/nzcV
         YDjozndKhpaWJy/buokypSavl6FL2DVpsZY3wYtFZtk4BWblk8xItEufPdVs8PCvkoyL
         vyJoOp77onksb9Rcgd3OzU6V1FztoH2MRLbKg=
Message-ID: <d58b966615c0a9978ec314ff1e5c53a7.squirrel@localhost>
Date: Wed, 25 Aug 2010 13:35:23 -0500
Subject: Allocating memory aligned on 1M boundary?
From: david.hagood@gmail.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to allocate a block of memory that is
a) contiguous in physical layout
b) large (ca. 1M or so)
c) aligned on a large boundary (e.g. 1M boundary) in physical address

I have a hardware device (specifically, the PCIe controller of a Freescale
8641D PPC microprocessor) that requires a large amount of RAM to operate,
and requires that RAM to be aligned on the size of the element (that is,
if you use a 1M buffer, then the starting address of that RAM must be
0x???00000 so that the address translation unit can map from the PCIe
address to the local address).

Hugepages might work, but I see no guarantee that the alignment would be met.

Yes, I could allocate 2x the desired size, then use that part of what I
allocate that is correctly aligned, but then I am guaranteed to waste half
of what I allocate.

I'd rather NOT use the boottime allocation tricks if possible.

Scatter/Gather is not supported by the hardware, so that is out.

Any good suggestions?


