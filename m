Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0JMIPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:15:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52772 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0JMIPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oTPaICFgf+gXDqSYb7xXiT9WKoHikLja624HjV4HyUtG7zON3f6z0xBhtsZalCoVfH
         muYecdHIHkQYPScqYiWQvfxendSMRHc7osv7WpLqzyWx6eLKoHsp7+A7OXbn5pNJ5I5v
         vN9ufsF8W0/zRJO/KWUtJCjoLK1de0xzKRDrg=
MIME-Version: 1.0
In-Reply-To: <4CB568C0.9030906@nokia.com>
References: <1286896642-27772-1-git-send-email-ext-andriy.shevchenko@nokia.com>
	<4CB568C0.9030906@nokia.com>
Date: Wed, 13 Oct 2010 11:15:20 +0300
Message-ID: <AANLkTi=EKu8qLYtb-vAsM5WT+ppzhX0-hxrcv6cWeiDY@mail.gmail.com>
Subject: Re: [PATCH] mmc: append a file to change host clock at run time
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:07 AM, Adrian Hunter <adrian.hunter@nokia.com> wrote:
>> +static int mmc_clock_opt_set(void *data, u64 val)
>> +{
>> +       struct mmc_host *host = data;
>> +
>> +       /* We need this check due to input value is u64 */
>> +       if (val>  host->f_max)
>> +               return -EINVAL;
>> +
>> +       mmc_set_clock(host, (unsigned int) val);
>
> Probably need to claim the host here otherwise you might
> be changing the clock while a request is in progress
Yeah, good catch. Will fix. Thanks.

-- 
With Best Regards,
Andy Shevchenko
