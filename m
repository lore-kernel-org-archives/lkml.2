Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1EQCGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:06:08 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:12904 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab1EQCGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:06:07 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com> <4DCAE163.2050602@metafoo.de> <CCD653B68482426EA47A12055C9E19E5@hacdom.okisemi.com> <4DCC384B.1020202@metafoo.de> <CA2B589B92704A439D8DF3E2EAD9750D@hacdom.okisemi.com> <4DCCA317.2030302@metafoo.de> <A3F1E9CB89D548289E8FC5BE11CB67C7@hacdom.okisemi.com>
Subject: RE: Question: GPIO driver how to get irq_base
Date: Tue, 17 May 2011 11:06:03 +0900
Message-ID: <45BB52C84795411599D19C7A7BA924E7@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <A3F1E9CB89D548289E8FC5BE11CB67C7@hacdom.okisemi.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwRHItBN20Rb4i8QSKgUhat4UZQ/gClEkQgACFVSyA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Modifying parameter of poll ( ) like below, poll ( ) becomes blocked correctly.
    pfd.events = POLLPRI | POLLERR
And I can confirm when GPIO driver detects edge changing,
the blocked poll  ( ) is released correctly. 

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> Tomoya MORINAGA
> Sent: Monday, May 16, 2011 7:39 PM
> To: 'Lars-Peter Clausen'; 'Grant Likely'
> Cc: linux-kernel@vger.kernel.org; toshiharu-linux@dsn.okisemi.com
> Subject: RE: Question: GPIO driver how to get irq_base
> 
> Hi,
> 
> Pch_gpio driver can become detecting falling/rising edge.
> I attached the latest GPIO driver, usermode TP and the result.
> 
> However, "poll( )" of gpio_tp behavior is different than I 
> anticipated. 
> The "poll" is not blocked. (The returned value looks good)
> 
> My anticipated behavior is
>   Execute gpio_tp (blocked at poll( ))
>   (Detect edge)
>   Interrupt handler of pch_gpio is called
>   Blocked poll( ) becomes released.
> 
> Let me know your opinion.
> 
> With Best Regards,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 

