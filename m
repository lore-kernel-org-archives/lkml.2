Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2BEXyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 18:54:41 -0500
Received: from nm37-vm6.bullet.mail.bf1.yahoo.com ([72.30.238.206]:27498 "HELO
	nm37-vm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752899Ab2BEXyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 18:54:40 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Feb 2012 18:54:40 EST
X-Yahoo-Newman-Id: 784830.58188.bm@omp1028.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:References:Mime-Version:In-Reply-To:X-Apple-Yahoo-Original-Message-Folder:Content-Type:Content-Transfer-Encoding:Message-Id:Cc:X-Mailer:From:X-Apple-Yahoo-Replied-Msgid:Subject:Date:To;
  b=gYVHL0wY0HDZhQv+9CQZphvNfOkAipORVpr/9ykJg9ahZanf0ikqg1zAnQDlP8UykH7MY9BqVvbar97NHawpNI7ZOnokB9Ybw/LYKe10ZqvKMsQSTVKYqB+Sc6zVX9qTK1Ox7KioSpbMVLV+wwRWCMGyZFfRN2psjVnYY8QNXdY=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5Amdbq8VM1nqIgxND1EBU5x90CzXoGbiA9t2W8Tn17UJzZm
 jwEe57PH9cwU2nAhEj_6cX6cWwBzIs_g.yBuD_TXUS4iqhEcX0oQkQw55j.2
 xIUv.FGjEkOZ0bR3_5zAz2rA0Y6M0S3qOSCQi121dQVpKq_nbCH9blqwf.Os
 KcX88yOWFIcGIz28S.TBuJPjiJfNTVsrZaLKJkZNK27mNYmGXnozgk8C0rwY
 gWTOVYXWtfy0t.v42BG.JCeBg1knoYl5GQBThGOZQh2OhhIrL_59WRhI.SjY
 t3jK.xaqdqPvrX0uwU5SxmHkqS8iwOxf_TyxHA5msjlXiqRrp4y721VL9896
 fL8Ne.OvyVOydEt00Q6zXpLNCQlWdJC587lPWThazYq3TUZhbI3PsXuFHJxT
 ewOKjr9TsDA5wcz9p9LLvkza3EVfDqDPkDCITn_mg7WlyVmLYEGTiRnibYA-
 -
X-Yahoo-SMTP: Jr5mEQOswBBUeQ6oSnePwwxoZ1M-
References: <20120205220950.812864962@pcw.home.local>
Mime-Version: 1.0 (iPhone Mail 8J2)
In-Reply-To: <20120205220950.812864962@pcw.home.local>
X-Apple-Yahoo-Original-Message-Folder: Inbox
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <4C7B5EA1-AE40-4E64-92CC-24277900A99E@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (8J2)
From: Luben Tuikov <ltuikov@yahoo.com>
X-Apple-Yahoo-Replied-Msgid: 2_0_0_1_8995447_AEHPjkQAABTYTy8CVQp7Hl4n/a8
Subject: Re: [PATCH 32/91] libsas: remove expander from dev list on error
Date: Sun, 5 Feb 2012 15:48:27 -0800
To: Willy Tarreau <w@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't this my patch? Are you submitting it as your own?

        Luben


On Feb 5, 2012, at 14:10, Willy Tarreau <w@1wt.eu> wrote:

> 2.6.27-longterm review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.
> 
> If expander discovery fails (sas_discover_expander()), remove the
> expander from the port device list (sas_ex_discover_expander()),
> before freeing it. Else the list is corrupted and, e.g., when we
> attempt to send SMP commands to other devices, the kernel oopses.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> Reviewed-by: Jack Wang <jack_wang@usish.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> drivers/scsi/libsas/sas_expander.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
> 
> Index: longterm-2.6.27/drivers/scsi/libsas/sas_expander.c
> ===================================================================
> --- longterm-2.6.27.orig/drivers/scsi/libsas/sas_expander.c    2012-02-05 22:34:34.059914940 +0100
> +++ longterm-2.6.27/drivers/scsi/libsas/sas_expander.c    2012-02-05 22:34:39.404915902 +0100
> @@ -839,6 +839,9 @@
> 
>    res = sas_discover_expander(child);
>    if (res) {
> +        spin_lock_irq(&parent->port->dev_list_lock);
> +        list_del(&child->dev_list_node);
> +        spin_unlock_irq(&parent->port->dev_list_lock);
>        kfree(child);
>        return NULL;
>    }
> 
> 
