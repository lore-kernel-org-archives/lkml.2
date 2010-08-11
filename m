Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0HKIQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:16:51 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:23041 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752588Ab0HKIQt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:16:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Ou4u4rq2Bvu1VCYS9mmvrVuZVa+9G1jPUPsFJF4zRxRp2kqtPvNS433XrmUeLY/u1tBnReDTVs/cOQQe1nJcWRekXD45zLxkzStROD1aibWPMnHGYUhy6LaFEowjc/6PFsj2Y/tiZkpvWI4k9ZLKoSklFPiaLf3fo+FyDPFOD9g=;
Message-ID: <908231.78161.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: i4Htk54VM1mpWaem0Uj9ha_wEzddG4CSJiYhwlbp_POOd8p
 XvYwKIbrE6ORkqxxTNTIaGo1yCY0bzr5gMqwMXXVNMfn00IreqH3BuTaEg.0
 7mxuxj4gpL_gufZR_P87jRqwbMw4o5qZ2YyS951OuUjxujcxJHjun2XrB5Hu
 kdoDipKYC6PKCKa8daTB30GzWUA1Ct5RlEVGXAmRV4y17HreStdPKRcAsBWO
 KgIC_YmpRBgfZbr60VvvAfUKttZKgtfQhXAIPqTZXaq_DxMqqluEX13PUjC6
 2YT2U.o_.08JQEner8sQjMN5hXCLBlXmb0fkHA2U.gtQyvHKtbWTGsLo-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 11 Aug 2010 01:16:47 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281433805.2016.36.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> result in bit flips,
> > rather data can not be delivered at all or
> command/parameters are invalid.
> Understood.
> However if I get MEMSTICK_INT_ERR, I should also look at
> status1,
> because there might be correctable error.
> 
> 

I don't remember the details, but it may be, that status1 errors do not
raise INT_ERR (or do not always raise?). The idea is, first you check
INT_ERR. If command completed successfully and you received the data, you
may still need to check status1 for possible bit flips.

Some experimentation may be required, especially for the case of
correctable errors. After all, they should not prevent the command from
successful completion, yet action should be taken on them (at the very
least - log warning, just like with normal disks).



      
