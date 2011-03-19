Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1CSUAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:00:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1CSUAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iOLs5tz1SlCcuAAnVwkopl39ebiALoIxHQEr9nZML4b0hX571qmVYY6GNnG29koO6Q
         QHxLhhx2D+0MvLAQIk+yRM1KnWzJ5px4kMDEppxu5cqAI7XDaL1faP+I/HKzk3JlFrFX
         qVwsFtrisgXOd9v5h6vsTJ5OaH5Bi7xH2oPqk=
MIME-Version: 1.0
In-Reply-To: <1300392635.17266.5.camel@mulgrave.site>
References: <1300392635.17266.5.camel@mulgrave.site>
Date: Sat, 19 Mar 2011 21:00:50 +0100
X-Google-Sender-Auth: KqpPsKJkJn3nyHS7fyPRoA-mlXs
Message-ID: <AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 21:10, James Bottomley <James.Bottomley@suse.de> wrote:
> This represents the usual round of driver updates (fcoe, lpfc, qla2xxx,
> zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa) plus one new
> driver (bnx2fc) and as a bonus we move libsas from the old libata eh to
> the new one paving the way for junking the old one (once we can get ipr
> converted).

> Martin K. Petersen (3):
>      sd: Logical Block Provisioning update

drivers/scsi/sd.c: In function ‘sd_prep_fn’:
drivers/scsi/sd.c:544: warning: ‘ret’ may be used uninitialized in this function

Actually it's in scsi_setup_discard_cmnd(), which is inlined:

        int ret;

        [...]

        switch (sdkp->provisioning_mode) {

                [...]

        default:
                goto out;
        }

        [...]

        ret = scsi_setup_blk_pc_cmnd(sdp, rq);
        rq->buffer = page_address(page);

out:
        if (ret != BLKPREP_OK) {

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
