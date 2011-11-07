Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1KGHdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 02:33:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43537 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1KGHdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 02:33:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
Date: Mon, 7 Nov 2011 08:33:46 +0100
X-Google-Sender-Auth: zP7WubeVMtAU7tCm9iK-rsPez1E
Message-ID: <CAO+b5-paS698V61BA8e4ZYstdqR4AKda2EKx4DHqv4gtR2ocPA@mail.gmail.com>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
From: Bart Van Assche <bvanassche@acm.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Anton Blanchard <anton@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 7:24 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I get lots more of these.  The obvious commit to point the finger at
> is 3308511c93e6 ("[SCSI] Make scsi_free_queue() kill pending SCSI
> commands") but the root cause may be something different.

It's probably the combination of commit 3308511c93e6 and patch
http://marc.info/?l=linux-scsi&m=132027101521282 that's triggering
that warning: the first commit changed scsi_free_queue() such that it
expects that its callers reset the queuedata pointer but the second
patch introduced a new scsi_free_queue() call that doesn't reset the
queuedata pointer first.

Bart.
