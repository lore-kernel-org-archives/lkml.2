Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0HDH5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:57:15 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:47796 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755113Ab0HDH5K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:57:10 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 03:57:10 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=e0KOII5zT9bzDpzL0uNUflM1TxUvEVmGVBNvNhK5YdhzHxOT/PzMiHCgfY+76X7KjBpmhhF7ooynjDMP300IvBg+f1FPDrVo97MvNu8t0bQIR2cmPojhnAb3851WTx/03Y0JBWHHlkGsuFnea5OIDAqw/X4IgrgLw5aB7AjJhRo=;
Message-ID: <441366.48179.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: jHMc080VM1mebxnmc3OpOxdlgVKmmh0aQvMhPboBtMZMc2M
 XeVM_ertd3Cw4PobbiRiZeRcyANJZdgdnZ7r00PU99qWoIxyuW53ufuTX98g
 a9gVIsur0J_9I6MISKRAyeZ6Ek7zqV1Ua49wTi85oli7Fe9mN4NVZU85tbog
 t5931BzR_XBYW.DftAIfmJQUiCE9Wh16afy8GXTLoBztSvILrZtckP_EAbJF
 XxaIx0OqRpkRSIbsEFzBfeWF0XaVT3RrzAcygNjty9j92vz9A_cWfUQvQKJ4
 sV2RdyvEaRrLMXds2FFWHC1nlc4QGX4KryJaYz_s-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 4 Aug 2010 00:57:08 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1280847186-11501-3-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see two immediate problems with this patch:

1. On cosmetic level, custom debug macros should not be employed. Device
core already have this functionality (dynamic debug levels and such). Please,
use dev_dbg and friends for print-outs.

2. On a structural level, I'd rather prefer host drivers to not start their
own threads. If you look at both current host implementations, they operate
in callback fashion. Apart from saving some resources, this reduces the
amount of problems encountered during suspend/resume and shutdown.



      
