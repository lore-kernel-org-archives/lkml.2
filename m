Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0F1XuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:50:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51802 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0F1XuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=Kwa6XKjPc+gdM2hxt9dvB9TWtYyypXwjteD35LNhN4+wjuP1Mair+dbvCY3fGCHgeu
         XFK8HTQ7FK+jZkpDX8kx/l3Pn3Fe+h/lHcGQoTqT7bVupNmvTi41MKqZ1zbQ+6V+GeOB
         n9P3I76qwjERw9qUrT9ZQJmrqUsbj4z65P5ZY=
MIME-Version: 1.0
Date: Mon, 28 Jun 2010 16:50:05 -0700
X-Google-Sender-Auth: gB20pnoFbzljafJKSxEtRrtsQRA
Message-ID: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
Subject: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

My Mac Pro hit this BUG every time it try to load module ioatdma.

This was first discover in FC 12 & 13 kernel. See redhat bug 605845.
https://bugzilla.redhat.com/show_bug.cgi?id=605845. I attach a picture
of the kernel panic on the bug.

The current git tree has it as well. The bug line number change a
little bit though.


		/* when halted due to errors check for channel
		 * programming errors before advancing the completion state
		 */
		if (is_ioat_halted(status)) {
			u32 chanerr;

			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
				__func__, chanerr);
			BUG_ON(is_ioat_bug(chanerr)); <---------------------------------
		}

The machine is a Mac Pro. The bug is reproducible 100%. Black list the
ioatdma module and the kernel boot just fine.

Any suggestion? I am not afraid to try out patches.

Thanks

Chris
