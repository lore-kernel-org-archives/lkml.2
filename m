Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2KIDHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:07:43 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51116 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2KIDHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:07:40 -0500
MIME-Version: 1.0
In-Reply-To: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
References: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
Date: Fri, 9 Nov 2012 08:37:40 +0530
Message-ID: <CAKohpomLbNhLhs3rgVaHp=R0kHVSN-sFePN_Nc205RxXczmu3A@mail.gmail.com>
Subject: Re: [PATCH 1/3] rtc: rtc-spear: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, spear-devel@list.st.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2012 20:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This patch frees rtc-spear driver from tension of freeing resources :)
> devm_* derivatives of multiple routines are used while allocating resources,
> which would be freed automatically by kernel.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Hi Andrew,

Can you please apply this fixup to this patch?

commit ad4a753df699e525d9c91a353f4406fd0e363599
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Nov 9 08:36:29 2012 +0530

    fixup! rtc: rtc-spear: Use devm_*() routines
---
 drivers/rtc/rtc-spear.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index 0c4805c..141fc94 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -363,11 +363,6 @@ static int __devinit spear_rtc_probe(struct
platform_device *pdev)
                dev_err(&pdev->dev, "no resource defined\n");
                return -EBUSY;
        }
-       if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-                               pdev->name)) {
-               dev_err(&pdev->dev, "rtc region already claimed\n");
-               return -EBUSY;
-       }

        config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
        if (!config) {
@@ -390,10 +385,9 @@ static int __devinit spear_rtc_probe(struct
platform_device *pdev)
                return status;
        }

-       config->ioaddr = devm_ioremap(&pdev->dev, res->start,
-                       resource_size(res));
+       config->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
        if (!config->ioaddr) {
-               dev_err(&pdev->dev, "ioremap fail\n");
+               dev_err(&pdev->dev, "request-ioremap fail\n");
                return -ENOMEM;
        }
