Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1IVRbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:31:19 -0400
Received: from nm35-vm0.bullet.mail.ne1.yahoo.com ([98.138.229.96]:26440 "HELO
	nm35-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752189Ab1IVRbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:31:18 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 13:31:17 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 903435.6780.bm@omp1014.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=ApLqGwbLi8VS5hnXuq4H8SGmU2LL8qImffxExhhcsM56G2HAuEDQOs3iAQoFKjHGcroBquFvCOookEEOeSlPkh15i5lJIC4v4hUM77g/rDCvhBneorCqZGfdJYPnUuZgft8DY9G4TRvweIBObhkEb/JcsF43e32Ex5Y8GeGy2oA=;
X-YMail-OSG: uHKIKMAVM1kXyC3zgwBu.o0F74j5ENUNX8gXn_14qnjzjnd
 0GK9IbE9iTDPR8OJyIcQb4DcEBnx8dUz05yyuM1RkB0j6oXOdf6xkBbPHVbr
 neVUOHaKQqz.Q7JdFf8nnSbqYwbxEVSC9vgLK0GT8AGamh.YAJJZNTnpzWzX
 oTSxhDjyjWdR8r2S9HyIIvX0jxNneOcmBiwGQwBTDjYun6kz_2sarVUsy2Kk
 zzLrq_PB7axpxhK7s3_0THleHa_M6_GjRJql8hq73TL0_Q2oLCYMQW73qteJ
 OifVCjcOnrXjT_INNpcubmz3IyHIn4hBxmm2LoDKsEfEDGjbuNKK.Kj2YFjb
 DT2PvkG6oE__TypWut5ZTw8hejg2xKxYsSl5c1bsfW34Kfwq5mJ_hjO0L.Uu
 n.VRhKsGBt1F1sAi6R5NED4YTXBPClgDptf98A3R85rG00tQxGcBYD6uhFu6
 9jpa1
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com> <20110922165014.GA12505@infradead.org>
Message-ID: <1316712267.95370.YahooMailNeo@web31801.mail.mud.yahoo.com>
Date: Thu, 22 Sep 2011 10:24:27 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110922165014.GA12505@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed this recently as well. I'm not sure if it is Yahoo or Firefox, or my cutting and pasting from Emacs as opposed to Xterm.



----- Original Message -----
> From: Christoph Hellwig <hch@infradead.org>
> To: Luben Tuikov <ltuikov@yahoo.com>
> Cc: James Bottomley <jbottomley@parallels.com>; "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Sent: Thursday, September 22, 2011 9:50 AM
> Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
> 
> On Thu, Sep 22, 2011 at 09:41:36AM -0700, Luben Tuikov wrote:
>>  Allow expander table-to-table attachments for
>>  expanders that support it.
>> 
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  ---
>>  ?drivers/scsi/libsas/sas_expander.c |?? 20 ++++++++++++++------
>>  ?include/scsi/libsas.h????????????? |??? 3 +++
>>  ?include/scsi/sas.h???????????????? |?? 14 ++++++++++++--
>>  ?3 files changed, 29 insertions(+), 8 deletions(-)
>> 
>>  diff --git a/drivers/scsi/libsas/sas_expander.c 
> b/drivers/scsi/libsas/sas_expander.c
>>  index f84084b..e8d0115 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct 
> domain_device *dev,
>>  ???? dev->ex_dev.ex_change_count = be16_to_cpu(rg->change_count);
>>  ???? dev->ex_dev.max_route_indexes = be16_to_cpu(rg->route_indexes);
>>  ???? dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
> 
> This looks completely garbled to me.
>
