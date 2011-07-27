Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1G0FG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:06:26 -0400
Received: from nm25.bullet.mail.ac4.yahoo.com ([98.139.52.222]:29625 "HELO
	nm25.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750736Ab1G0FGY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:06:24 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 01:06:24 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 497026.40046.bm@omp1014.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Bi6xCTp6b26atii1xrZTvHzhV/ULD86uesCY+zP3+izCTmZo7CtuuqEtV0IN0UpvfkiWPEf7hnsjCU7k+RXG8zYI9mGgBkgf/gNGPSXuMIjsGhM82HSrTG4ujri/PraZ1nsabOgw7owR0bO6OglsHC9OCetYDqlxhjQ83ttEhsw=;
X-YMail-OSG: WOGrV8cVM1n.10.vtwD4dr6XrnquekzhnEs4lGpsb8cE7.A
 qLkgesYoTOujeYshlmuueWYRU_rjiRpDyZSjeFzK6TBopjC5.fCJjgcdPoQX
 0T_HKSq.q03PaW3g0vQ4DgusfGIxtOgF6A1Y1u87h9Z1hciR_BN8eCBowX2S
 jzrtsIMOZw8yyDmpn9DETXkhXYx3AVL3ouVWvtRphyJaE_PJ_FCS2p9ISbPH
 UF5E69hTd3N4pjDhE6ZiS.KFeA.mmM5Kg3E2u2JFHdOKjYs8szn1lBWvKQFL
 Lqba2vnHDSNKmEYyb3OVtNP3JiK162mbPRiuAli9CNMSFErZ5QlmywSGJhw6
 GdoVnkdft4O6YTdJZAVQIg1EBNBlbpHsvlBVUEfN1cIp2dFP_YOmhuzJKPKb
 kzf01oOwQ2Gzj
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com> <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
Message-ID: <1311742776.42252.YahooMailNeo@web31810.mail.mud.yahoo.com>
Date: Tue, 26 Jul 2011 21:59:36 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
To: Jack Wang <jack_wang@usish.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>
In-Reply-To: <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

> From: Jack Wang <jack_wang@usish.com>
> To: 'Luben Tuikov' <ltuikov@yahoo.com>; 'James Bottomley' <James.Bottomley@suse.de>; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Cc: 
> Sent: Tuesday, July 26, 2011 8:26 PM
> Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
> 
> [PATCH] [SCSI] libsas: remove expander from dev list on error
>> 
>>  If expander discovery fails (sas_discover_expander()),
>>  remove the expander from the port device list
>>  (sas_ex_discover_expander()), before freeing it. Else
>>  the list is corrupted and, e.g., when we attempt to send
>>  SMP commands to other devices, the kernel oopses.
>> 
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  ---
>>   drivers/scsi/libsas/sas_expander.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>> 
>>  diff --git a/drivers/scsi/libsas/sas_expander.c
>>  b/drivers/scsi/libsas/sas_expander.c
>>  index 874e29d..f84084b 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
>> 
>>       res = sas_discover_expander(child);
>>       if (res) {
>>  +        spin_lock_irq(&parent->port->dev_list_lock);
>>  +        list_del(&child->dev_list_node);
>>  +        spin_unlock_irq(&parent->port->dev_list_lock);
>>           kfree(child);
>>           return NULL;
>>       }
>>  --
> [Jack Wang] Looks reasonable, thanks for fix this.
> You can add my Reviewed-by: Jack Wang <jack_wang@usish.com> if needed.
>
