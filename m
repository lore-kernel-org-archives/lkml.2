Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1DFLlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:41:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47367 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1DFLlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r2IAm8jee3qptgNGGfWUd36F5PNpGjvw1Fw1A1cgzJ5jfjCIew++jvDlO0cPWO0Djx
         81Zo9TFEPOYVu62SFwSjnvbDt4dvUUkYsqcIC/Pb0uuc1KfRFdIMrnSw6H7Kw1L0t8ia
         yT80L8ZV7erumQe/nW/g4lQSU6a+ywv+jCM0o=
MIME-Version: 1.0
In-Reply-To: <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110301153438.GB15633@suse.de> <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 6 Apr 2011 13:41:01 +0200
Message-ID: <BANLkTik29+u0A-uuQG3KtjQxNO_KpBMShg@mail.gmail.com>
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
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>
> I wasn't sure what to return when dev_set_drvdata is called with
> dev=NULL.  I choosed 0, but -EINVAL would be OK for me, too. What do you
> think?

This code was introduced by:

commit b4028437876866aba4747a655ede00f892089e14
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Mon May 11 14:16:57 2009 -0700

    Driver core: move dev_get/set_drvdata to drivers/base/dd.c

Before this patch, driver writers could assume that dev_set_drvdata()
never fails. And, dev==NULL would cause an imediate NULL dereference
(equivalent to BUG_ON(!dev), BTW). And, if dev_set_drvdata() fails
(silently as it is now) it's going to BUG later anyway.

I think it's best to revert that commit instead of fixing this up.

Best Regards,
Micha³ Miros³aw
