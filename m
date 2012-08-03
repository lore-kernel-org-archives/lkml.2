Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2HCJvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:51:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42894 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2HCJve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:51:34 -0400
MIME-Version: 1.0
In-Reply-To: <87wr1g5n0r.fsf@abhimanyu.in.ibm.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com> <87wr1g5n0r.fsf@abhimanyu.in.ibm.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 3 Aug 2012 11:51:13 +0200
Message-ID: <CAPXgP12jvZXEhg7YXkEnG9oBtEzvLhMdgjhY3kD-wFO+ppE+ug@mail.gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Vikram Pandita <vikram.pandita@ti.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 11:43 AM, Nikunj A Dadhania
<nikunj@linux.vnet.ibm.com> wrote:
> On Fri, 3 Aug 2012 02:16:18 -0700, Vikram Pandita <vikram.pandita@ti.com> wrote:

>> +static size_t print_cpuid(u8 cpuid, char *buf)
>> +{
>> +
>> +     if (!printk_cpuid)
>> +             return 0;
>> +
>> +     if (!buf)
>> +             return 4;
>> +

> Firstly, why this magic number?
> Secondly, if buf is NULL, why should you increment?

The !buffer logic is used when we only calculate the size of the
output buffer, but do not print to it. It's just an optimization. And
yes, the number returned should match the number of chars that would
have been printed, so this does not look right.

Kay
