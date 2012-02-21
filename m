Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2BUOjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:39:24 -0500
Received: from mx17.lb01.inode.at ([62.99.145.19]:53264 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753328Ab2BUOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:39:23 -0500
X-Greylist: delayed 8706 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 09:39:22 EST
Message-ID: <4F43AC8D.5090508@hale.at>
Date: Tue, 21 Feb 2012 15:39:09 +0100
From: Michael Thalmeier <michael.thalmeier@hale.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, michael@thalmeier.at,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i.MX31: mxc-rnga: implement waiting for data in driver
References: <1329826410-21739-1-git-send-email-michael.thalmeier@hale.at> <CAOMZO5BGVa0HRKqv9nKQUy9iGnQ3FV_6OnguMyk3rAinaJkb6w@mail.gmail.com>
In-Reply-To: <CAOMZO5BGVa0HRKqv9nKQUy9iGnQ3FV_6OnguMyk3rAinaJkb6w@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: q1LEdOds016740
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1330439965.63704@d84RF2oqnthvM1/AHGA1/A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-21 14:29, Fabio Estevam wrote:

> On Tue, Feb 21, 2012 at 10:13 AM, Michael Thalmeier
> <michael.thalmeier@hale.at> wrote:
> 
>> -static int mxc_rnga_data_present(struct hwrng *rng)
>> +static int mxc_rnga_data_present(struct hwrng *rng, int wait)
> 
> This looks good, but ...
> 
>>  {
>> -       int level;
>> +       int level, i;
>>        void __iomem *rng_base = (void __iomem *)rng->priv;
>>
>> -       /* how many random numbers is in FIFO? [0-16] */
>> -       level = ((__raw_readl(rng_base + RNGA_STATUS) &
>> -                       RNGA_STATUS_LEVEL_MASK) >> 8);
>> +       for (i = 0; i < 20; i++) {
> 
> Why the magic "20" here?
> 
> It would be better to add a proper timeout mechanism instead, such as
> time_after(jiffies, timeout)
> 


I am absolutely with you.
The point is only that this is the behaviour of nearly all hw_random
drivers, and I basically just copied it over into this driver.


--
Scanned by MailScanner.

