Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab0IZXE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 19:04:26 -0400
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:37501 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932266Ab0IZXEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 19:04:24 -0400
Message-ID: <4C9FD161.2000606@fluff.org>
Date: Mon, 27 Sep 2010 00:04:01 +0100
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Sundar <sunder.svit@gmail.com>
CC: Kenneth Heitke <kheitke@codeaurora.org>, tsoni@codeaurora.org,
        Daniel Walker <dwalker@codeaurora.org>, sdharia@codeaurora.com,
        linus.walleij@stericsson.com, Crane Cai <crane.cai@amd.com>,
        srinidhi.kasagar@stericsson.com, linux-arm-msm@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        arve@android.com, linux-i2c@vger.kernel.org, ben-linux@fluff.org,
        swetland@google.com, khali@linux-fr.org,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1283907557-1874-1-git-send-email-kheitke@codeaurora.org> <AANLkTimHQ=ag5z+SKbGrm5BD-eF+xcDuKp4R_=4tf3cP@mail.gmail.com>
In-Reply-To: <AANLkTimHQ=ag5z+SKbGrm5BD-eF+xcDuKp4R_=4tf3cP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/10 20:01, Sundar wrote:
> Hi Kenneth,
> 
> just some error codes and leaks if I am right :)
> 
> On Wed, Sep 8, 2010 at 6:29 AM, Kenneth Heitke <kheitke@codeaurora.org> wrote:
>> +
>> +static int __devinit
>> +qup_i2c_probe(struct platform_device *pdev)
>> +{
>> +
>> +       qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +                                               "qup_phys_addr");
>> +       if (!qup_mem) {
>> +               dev_err(&pdev->dev, "no qup mem resource?\n");
>> +               return -ENODEV;
> 
> I think this should be -ENXIO instead of -ENODEV?

I think both are inappropriate here, -ENXIO is an IO failure
and -ENODEV is 'device is not here'. However, some people don't
like the use of things like -ENOENT (filesystem errors) for this
sort of situation. ENOTSUP might be something you could use.

As a note, both ENXIO and ENODEV will be taken by the device
framework as a device is not there at-all and not display any
error to the user (which is annoying if you then forget to
do anything about it)

As a note, you may want to have a look at devres to offload the
tracking of the requested and mapped resources.
