Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab2JYKEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:04:11 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49880 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884Ab2JYKEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAJLyvQzpo19hhwG9a4GEv0HCdJtfSJz_ASRnE-WKbwbMa58Akw@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=L-Xz90h90Q78gr7enOHK3u1TwHSs-QPQNE=0896SjRA@mail.gmail.com>
	<CAJLyvQxEAeP__drUAAz6D_UeeDRvdqKdmim3xAO7sXP8cCM8=g@mail.gmail.com>
	<CAKohpomZZiXnnkUC=9ZQoux1BVh+uJZw_oM1Ahndua2PZaKiDw@mail.gmail.com>
	<CAJLyvQw7=ucSTXH8YyPrm6LS8uDyxJkWGEVP2jQ3FL=cYN7frg@mail.gmail.com>
	<CAJLyvQzpo19hhwG9a4GEv0HCdJtfSJz_ASRnE-WKbwbMa58Akw@mail.gmail.com>
Date: Thu, 25 Oct 2012 15:34:08 +0530
Message-ID: <CAKohpo=grLyatiDEvSi_P+atRJ=JBVs_eWKbtumEkWenPr3EDg@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] Thermal: Add ST-Ericsson DB8500 thermal dirver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 15:26, Hongbo Zhang <hongbo.zhang@linaro.org> wrote:

> Verish, see the codes in include/linux/interrupt.h:

s/verish/viresh :)

> static inline int __must_check
> devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
>                  unsigned long irqflags, const char *devname, void *dev_id)
> {
>         return devm_request_threaded_irq(dev, irq, handler, NULL, irqflags,
>                                          devname, dev_id);
> }
> devm_request_irq is devm_request_threaded_irq

See carefully what's happening here.

All interrupt types have a common irq_desc type in kernel. This has
few pointers for every
interrupt line:
- List of handlers to call from interrupt context
- handlers to call from process context via a thread.

So, the internal implementation is exactly same... The only difference
is which pointer
should be called in.

the devm_request_threaded_irq() called from devm_request_irq() has
following params
handler: For irq to be called from interrupt context (param 3)
NULL: For irq to be called from process context. (param 4)

So, that means  normal request_irq type only.

In your case, you have passed interrupt context pointer as NULL and
process context
one as handler. So that's an issue.

--
viresh
