Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1DTJKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:10:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38478 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1DTJKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kttUoNDuHGg+AkoKtIcu0Iy97X/c45erPqWig0GiCiqTU9DDAEo5PImejUzZIpg3k2
         fLV1ES7f2Dh27MVCzp9nkvHHjj2CGK+g6KkD8jlNKdU46CMouB1w19TLCX3nbtnPxiY3
         eHxmZ22zxzPJ0aovpFu86h5I08WJBV5IyhRF0=
MIME-Version: 1.0
In-Reply-To: <20110419235812.GA4619@kroah.com>
References: <BANLkTi=MjDqawZx=+fKjaAs5SPfGQDEgVQ@mail.gmail.com>
 <1302547378-14639-1-git-send-email-u.kleine-koenig@pengutronix.de> <20110419235812.GA4619@kroah.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 20 Apr 2011 11:09:56 +0200
Message-ID: <BANLkTi=q8jfEaLByZVZPHHYp_5PTK-36cw@mail.gmail.com>
Subject: Re: [PATCH v2] driver core: let dev_set_drvdata return int instead of
 void as it can fail
To: Greg KH <greg@kroah.com>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Greg KH <greg@kroah.com>:
> On Mon, Apr 11, 2011 at 08:42:58PM +0200, Uwe Kleine-König wrote:
>> Before commit
>>
>>       b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
>>
>> calling dev_set_drvdata with dev=NULL was an unchecked error. After some
>> discussion about what to return in this case removing the check (and so
>> producing a null pointer exception) seems fine.
> I'm confused by this thread, care to resend all of these in a series
> against the latest linux-next tree?

I'd argue that dev_set_drvdata() should never fail. All current
drivers depend on this, and if dev_set_drvdata() fails, user will get
an OOPS a short while after the device finishes initializing (or maybe
even before that if callbacks are involved).
Allowing dev_set_drvdata() to fail will need putting a lot of
boilerplate code into drivers for no real gain.

Please consider reverting commit
b4028437876866aba4747a655ede00f892089e14 instead of "fixing" issues it
generates.

Best Regards,
Michał Mirosław
