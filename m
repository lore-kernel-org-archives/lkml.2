Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363Ab2EJAC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:02:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22495 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2EJAC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:02:57 -0400
X-AuditID: cbfee61a-b7b97ae000004342-e7-4fab05b0dda2
Message-id: <4FAB05B0.2030906@samsung.com>
Date: Thu, 10 May 2012 09:02:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I have question for supporting irq_domain of MAX8997
References: <4FA9F16D.9090106@samsung.com>
 <CAJuYYwRDe_KyXnPxZq_fGyHuYAB=e76AaRZwoe9UjUer=QX3YA@mail.gmail.com>
In-reply-to: <CAJuYYwRDe_KyXnPxZq_fGyHuYAB=e76AaRZwoe9UjUer=QX3YA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas,

On 05/09/2012 11:27 PM, Thomas Abraham wrote:

> The irq domain support for max8997 irq is already posted. I am yet to
> address some of the review comments for those patches and hence the
> max8997 dt (+ irqdomain) patches are still work in progress. But the
> irq domain support for max8997 is complete.

I did see your patch for irq_domain support for max8997 in below git repository.

http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=shortlog;h=refs/heads/for-next

But, I checked that your patch was reverted because it breaks the build
of the muic driver
reported by Stephen Rothwell. You can check this following url.
http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=82b719b11fd750188c125078ad6a6c0d23219dfb

Also, Do you test irq domain of MAX8997 with max8997-muic driver or others?
While looking through the drivers/mfd/max8997-irq.c, I could not find
initialization code
of max8997->irq_domain(field of 'struct max8997_dev'). When tested your
patch with
max8997-muic driver, max8997->irq_domain variable is NULL. I think that
you set only
local variable(struct irq_domain *domain) in max8997_irq_init().

Thank you,
Chanwoo Choi
