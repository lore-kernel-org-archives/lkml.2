Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1LOKKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:10:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57512 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1LOKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:10:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111215072103.GA13747@kroah.com>
References: <20111215173754.87103f66f6188693933cb539@canb.auug.org.au> <20111215072103.GA13747@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 15 Dec 2011 11:10:26 +0100
Message-ID: <CAPXgP102rHBUAik0pBZuMVG0JVqHeJ8cNgSOzGWci3MBDoRUSg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 08:21, Greg KH <greg@kroah.com> wrote:
> On Thu, Dec 15, 2011 at 05:37:54PM +1100, Stephen Rothwell wrote:
>> After merging the driver-core tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/xen/xen-selfballoon.c:305:36: error: expected ')' before '(' token
>> drivers/xen/xen-selfballoon.c:327:42: error: expected ')' before '(' token
>> drivers/xen/xen-selfballoon.c:349:48: error: expected ')' before '(' token
>>
>> etc ...
>>
>> [Along with many warnings like:
>>
>> drivers/xen/xen-selfballoon.c:284:8: warning: 'struct device_attribute' declared inside parameter list [enabled by default]
>> ]
>>
>> Presumably caused by commit drivers/xen/xen-selfballoon.c ("xen-balloon:
>> convert sysdev_class to a regular subsystem").
>
> Ick, Kay, can you make a fix-up patch?
>
> And here I thought I built xen in my test kernel, crap, sorry about
> that.

It seems it's a compiler version issue, or similar. I'm unable to
reproduce it here, allmodconfig and the Xen part gets through without
any problems.

I guess we both have very recent systems again. :)

I expect adding a device.h include will fix it. I'll send you a patch.

Thanks,
Kay
