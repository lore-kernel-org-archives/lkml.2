Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab1DIADG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 20:03:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38027 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1DIADE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 20:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cniVqubJPWsMMc7F3Xw3atfSrtWD6RsKsd10VhplseGFHRV2p8kx4Eq+OaAIpFlnZn
         BybMY+23UfYe71aMHOOXwVzzNlWorZdQlaXwh95KbsaPcSVUT929Q3H/QYvx24iPg7zE
         pU98rTl/EKZn+52hR14GCpyqIsLwdwXuImflI=
MIME-Version: 1.0
In-Reply-To: <1302292554.1664.12.camel@Joe-Laptop>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
	<1302290881.1664.7.camel@Joe-Laptop>
	<BANLkTi=QwBOxfxy13PxeX+LRuccV_p06zA@mail.gmail.com>
	<1302292554.1664.12.camel@Joe-Laptop>
Date: Sat, 9 Apr 2011 02:03:03 +0200
Message-ID: <BANLkTimQBAHgFaH0RVCOYBGSKuHN2Dprmw@mail.gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Joe Perches <joe@perches.com>:
> On Fri, 2011-04-08 at 21:46 +0200, Rafał Miłecki wrote:
>> 2011/4/8 Joe Perches <joe@perches.com>:
>> > On Fri, 2011-04-08 at 21:45 +0200, Rafał Miłecki wrote:
>> >> diff --git a/include/linux/axi/axi.h b/include/linux/axi/axi.h
>> > []
>> >> +#define axi_info     pr_info
>> >> +#ifdef CONFIG_AXI_DEBUG
>> >> +#define axi_debug    pr_debug
>> >> +#else
>> >> +#define axi_debug    do { } while (0)
>> >> +#endif
>> >> +#define axi_err              pr_err
>> >
>> > I think redefining standard functionality like
>> > this doesn't gain anything and loses some basic
>> > grep capability.
>>
>> But on the other hand using:
>> pr_info, pr_err, BUT axi_debug
>> can easily lead to mistakes.
>>
>> Or is this possible to re-define pr_debug locally?
>
> It is, but is that CONFIG_AXI_DEBUG actually
> worthwhile?
>
> If you think so, doesn't adding this to the Makefile
> give you the same capability?
>
> ccflags-$(CONFIG_CONFIG_AXI_DEBUG) := -DDEBUG

But pr_debug does not depend on DEBUG define:
http://lxr.free-electrons.com/source/tools/perf/util/include/linux/kernel.h#L94

How do you expect -DDEBUG to affect pr_debug? Could you explain this
to me, please?

-- 
Rafał
