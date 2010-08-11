Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0HKIIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:08:55 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:47223 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755852Ab0HKIIw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:08:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=vslq7zK+WqjnQcm2TZcIkRpR+jwVqA4MphZhbFid1hV5TlIMkK5JTn1frmLQ/zpNDaOCfC8MbtqHPsK2vPG4U4XMFWg5UphX5yLx1c7/sFUZ1ycgEU981MJoRp+sAY3jK7rjXQnyc+sNjvJT5V5D5tXy+MO8Yiub4wJcg4nOU0Q=;
Message-ID: <199584.21009.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: n0IK4F8VM1kTDWXo.PlaWY1lDx.SfIGwSrzfgxLRvVXidoK
 G3h0G5eYczsSHa_k8vUD9fvzkelBwauXDsXMtXemG43ycq.WbhQZ1jm6LzZN
 HiI8njiZTQR3u5qaSZruglyzo_fKwUHoBQUSB967mbAJuhOHN_sXBUvxJc6d
 hLtj6hiHVfxF6KTVIK.SESOIUE7mT5y51rfXOL1ngMVGUwTmtSsK0KUgC3iU
 lwrftJSGGwH49wR.ZMJC7B.Y8gXoMNrEEmuf74b0r19JSnGG_ZxgOZu_1Vlp
 JBH2g2fInV_oBrtC7D9a_yaDO.c.tCtodrU8NPhHK6q9iNdfwvE.fEw--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 11 Aug 2010 01:08:51 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281433678.2016.34.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I know everything you have just said.
> I just want to point out that code in many places assumes
> that register
> window is the same as set on device initialization.

It's not.
Can you please point at a particular place?

> > But, if you're using the auto incrementing write, you
> will have to write
> > extra register for every page transferred.
> But what if I fill extra register with 0xFF?
> And besides on reads, the fact that I *write* the extra
> register before
> I execute read command shouldn't matter at all regardless
> of what I
> write there.
> On writes however I *do* need to write extra register
> anyway with proper
> values.
> 
> Therefore I see no reason why I can't set write window to
> cover both
> param and extra register, and leave it always like that.

Because when you do autoincrementing write you _can not_ write into param register. You will break the command execution.

On the other thought, it may be unnecessary to write unique extra data to every page, so one full register write at the beginning of the command may do. Considering, that legacy memstick is not going to evolve, this may be reasonable assumption.



      
