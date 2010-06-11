Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab0FKTmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:42:50 -0400
Received: from n5.bullet.mail.gq1.yahoo.com ([67.195.9.85]:42546 "HELO
	n5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756853Ab0FKTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:42:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 624564.20447.bm@omp129.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=CYriASPkKC0RL0yiPXHJI4UXZUk/XDP/YH03B1uXxUDnSfuZJvECtxowmhNB61k1Uc+XLNS/VrxmAoarUZ9Ps2m8h2o79GaiQ52tVLqsy6zEc8t9wMBWLw0bmbJ40abjnQQ3siQD0LMHgmOVZ92rNcbrhuFoPAJKMB0cBr7vxGE=;
Message-ID: <536217.22740.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: ZSXJwXkVM1kTROHZj5uTPSUPv7A8kJVRVRVmzYDpPVuw5LE
 WwnhFM7T6wtWl.1P.kPAIV13HNjyk_vJZl075LUayM6ZRsrg3dF8_3ifx2zp
 9VLhNJwbyhv8wM3R79N_gK8o5kPSjp1sE6GhiLJD1C5A6XO.HWehSxQX9zIK
 cQpkToe2fOzQN_pkZmQEJFwjXbk78.McJTcQrpIqxe04UJgjUQzsyoEiw4wT
 ctNZpG0ZyOfA3ZEwhxlhuFF2xrXdtCqV27gJQPvEUxRitJQq0mDJKncNOFtc
 aSoFZxPwvdy2X2kr32iKs43.5o_X8IbAZzHeVxVDVvCGW5khpJns0wX3CqV0
 To7cSEnmbRUczQpJg6mws5nZWE0s-
X-Mailer: YahooMailClassic/11.1.3 YahooMailWebService/0.8.103.269680
Date: Fri, 11 Jun 2010 12:42:47 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH] Fix the outstanding issue with hangs on insert/removal of mmc cards
To: linux-mmc <linux-mmc@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <1276282801.8557.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 6/11/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> After thinking a lot about how to fix properly the hangs
> caused by
> insert/removal of mmc card during suspend/resume, and default behavior
> of not trusting the card persistence over suspend,

Right; there are two types of driver:  ones
that can correctly report whether the card
has been removed ... and ones that can't  That
default behavior presumes the latter. 

The MMC/SD framework doesn't know about these
two types

(For
reference:  the easy way to do the former involves
setting up the GPIO used for card detect as a
(wakeup?) IRQ source.

> First of all there are 2 types of removal possible. First
> one happens
> when system detects that some device is gone. At that point
> there is
> really no point in syncing it.

One suggestion was syncing before suspend...
but that would require coordinating the
block layer and PM framework.  That seems
like it'd be generally a wise thing to do;
no point in losing the write cache, ever.


> The other type of removal is controlled removal, usually on user  request.





