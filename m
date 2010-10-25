Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0JYQMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:12:55 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:31952 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751414Ab0JYQMx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:12:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=oGQFXD3xrevW6ftV+x7xOKRiHPeoRzfOd48QC3/+QbQNjfoa1U4j28S4vaxhg1G74+6Ryj3aaXe/2xtl6dXCw9515OXnTZX9dbsr0WS9IErUbOIgv+kLgHyQhM5RLB7dD3Dun4iSVbFCnKeZIRo61nSPw4njdoeIXpb/yTNdxko=;
Message-ID: <327472.13750.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: nEKHvX0VM1n.nn2rPb5SNVSDoctUvtflg1DrIlHLGEGbPPu
 zDZOVaGEDZ5YyAhcRSQRDouCcOm5T16dvayWudhz9fPokVyir7ibBBms0inu
 LhWrGQTWAdhpVi1NcOuR.8eakqbfWpDz04GKhgFluuTDOUjZKzYpZttfpqMQ
 nqYkhplvFPqie7kCD_00pZ6_kNaaYarNmD2c6ZLrDV2vnh.edzW3154YBIj0
 pouYfibAeX.EPYCwYUGeyxMROx44aU1FdrG7RpP5.XGTeDpRL0HyZGTLuv9S
 VKJk7OdWh8RlgIXzO9vuhH427vFxDSaJHNLfZIDiR.we5_RNdCX6SIsOZoO2
 PtOKldRIgzC7yj0v.psb1sgwYs6jL6GBip61QMWrI_aR4W_XF
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:12:51 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 23/29] memstick: jmb38x_ms: use DMA for all TPCs with len greater that 8 by default
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-24-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 23/29] memstick: jmb38x_ms: use DMA for all TPCs with len greater that 8 by default
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> This is to workaround a wierd
> hardware bug:
> 
> If PIO write is used, and then after it DMA write is used,
> DMA
> engine stops doing writes.
> That condition even persists after device reset.
> 
> To be maxumum safe, we do dma to a scratch page
> and memcpy from/to it.
> 
> Besides this change should just improve performance.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---

I have not noticed this one before, and for all I know the driver was
tested at Jmicron.
Can you explain the issue a bit more?



      
