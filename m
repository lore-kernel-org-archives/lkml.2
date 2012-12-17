Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2LQO16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:27:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54050 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2LQO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:27:56 -0500
Message-ID: <50CF2BE5.8070804@redhat.com>
Date: Mon, 17 Dec 2012 15:27:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 0/2] add per-device sysfs knob to enable unrestricted,
 unprivileged SG_IO
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/11/2012 18:25, Paolo Bonzini ha scritto:
> Privilege restrictions for SG_IO right now apply without distinction to
> all devices, based on the single capability CAP_SYS_RAWIO.  This is a very
> broad capability, and makes it difficult to give SG_IO access to trusted
> clients that need access to persistent reservations, trim/discard, or
> vendor-specific commands.  One problem here is that CAP_SYS_RAWIO allows
> to escape a partition and issue commands that affect the full disk,
> thus making DAC almost useless.
> 
> For simplicity, this series attempts to solve one case only: you want
> to pass through almost everything, but still run as confined as possible.
> This is for example the case for virtualization, where more complex
> filtering can be done just as easily in userspace, in the virtual
> machine monitor.  (This does mean the filter can be subverted if the
> guest can escape the QEMU jail, but a more generic approach involving
> a bitmap was NACKed).
> 
> Ok for 3.8?

Ping... Jens, I haven't seen any pull request for 3.8 from you.  Are
these patches on your radar?  Tejun acked both of them.

Paolo

> v2->v3: change bitmap filter to boolean
> 
> Paolo Bonzini (2):
>   sg_io: pass request_queue to blk_verify_command
>   sg_io: introduce unpriv_sgio queue flag
> 
>  block/blk-sysfs.c      |   32 ++++++++++++++++++++++++++++++++
>  block/bsg.c            |    2 +-
>  block/scsi_ioctl.c     |    9 +++++----
>  drivers/scsi/sg.c      |    3 ++-
>  include/linux/blkdev.h |    6 +++++-
>  5 files changed, 45 insertions(+), 7 deletions(-)
> 

