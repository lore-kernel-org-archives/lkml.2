Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2HaOas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:30:48 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35019 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab2HaOar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:30:47 -0400
MIME-Version: 1.0
In-Reply-To: <1346413543.9709.45.camel@sauron.fi.intel.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
	<1346413543.9709.45.camel@sauron.fi.intel.com>
Date: Fri, 31 Aug 2012 10:30:46 -0400
Message-ID: <CAMiH66H5rfzfPJ8trbnHxWVL4icHVBq+QYVhS79HQa_emoTJmQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mtd: cmdlinepart: make the partitions rule more strict
From: Huang Shijie <shijie8@gmail.com>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, shmulik.ladkani@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 7:45 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sun, 2012-08-26 at 13:21 -0400, Huang Shijie wrote:
>> There are typically two types to set the mtd partitions:
>>
>> <1> set with the `size`, such as
>>     gpmi-nand:100m(boot),100m(kernel),1g(rootfs)
>>
>> <2> set with the `offset`, such as
>>     gpmi-nand:100m@0(boot),100m@100m(kernel),1g@200m(rootfs)
>>     gpmi-nand:1g@200m(rootfs),100m@0(boot),100m@100m(kernel)
>>
>> If we mix these two types, such as:
>>      gpmi-nand:100m@0(boot),100m(kernel),1g@200m(rootfs)
>>      gpmi-nand:1g@200m(rootfs),100m@0(boot),100m(kernel)
>>
>> It's hard to understand the cmdline. And also it is hard to sort the
>> partitions in this mixed type. So we explicitly forbid the mixed type.
>
> So "explicitly forbid" is just to add a "do not do this" comment?
>
Do you think we should change the code to forbid this mixed type?

Huang Shijie
