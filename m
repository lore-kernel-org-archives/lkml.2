Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab1DFLZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:25:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60540 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1DFLZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Iafw4PW32tcTh3OHyGBXsaJAtqYlVzTvkJB1C0/7EXy1da6wIHafzt10q/tvXq8WUK
         RvGtV2sYsQaeZogFGqpWtcm/OOZ3pBNf+euau+Tkho9ct2KkJzpa4RDfybN+Pghf+pEO
         qja622mM68V79aJk6t6CG1PnQbV0KNq4hE3cE=
MIME-Version: 1.0
In-Reply-To: <20110406110623.GC13963@pengutronix.de>
References: <20110301153438.GB15633@suse.de> <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <BANLkTikVpacjh1EsQQoaQRN3j-kxxjr7qA@mail.gmail.com> <20110406110623.GC13963@pengutronix.de>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 6 Apr 2011 13:25:04 +0200
Message-ID: <BANLkTi=MjDqawZx=+fKjaAs5SPfGQDEgVQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] driver core: let dev_set_drvdata return int instead
 of void as it can fail
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-arm-kernel@lists.infradead.org,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/6 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello,
> On Wed, Apr 06, 2011 at 11:36:46AM +0200, Micha³ Miros³aw wrote:
>> 2011/4/6 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> > ---
>> > Hello,
>> >
>> > I wasn't sure what to return when dev_set_drvdata is called with
>> > dev=NULL.  I choosed 0, but -EINVAL would be OK for me, too. What do you
>> > think?
>> Why not just BUG_ON(!dev)? Is there a case when you might call this
>> with dev==NULL that's not a driver bug?
> I think BUG_ON is too harsh. Will resend with -EINVAL.

Maybe just WARN_ON, then? Please? ;-)

Error return with no other visible sign is easy to miss for driver
writers. Big bad backtrace in dmesg on the other hand attracts
attention.

Best Regards,
Micha³ Miros³aw
