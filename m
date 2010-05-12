Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0ELTNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:13:10 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52813 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab0ELTNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <20100512190814.GA9674@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de> 
	<20100511174708.GA26777@oksana.dev.rtsoft.ru> <20100511175812.GH30801@buzzloop.caiaq.de> 
	<20100511182347.GA31831@oksana.dev.rtsoft.ru> <20100511222825.GJ30801@buzzloop.caiaq.de> 
	<20100512181546.GA4804@oksana.dev.rtsoft.ru> <20100512183806.GA28658@suse.de> 
	<20100512190814.GA9674@oksana.dev.rtsoft.ru>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 12 May 2010 21:12:46 +0200
Message-ID: <AANLkTimQq30DklQUDBokPXsLiXKsuiaCUFg_5ddkJbXa@mail.gmail.com>
Subject: Re: [PATCH] Introduce {sysfs,device}_create_file_mode
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 21:08, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Wed, May 12, 2010 at 11:38:06AM -0700, Greg KH wrote:
>> On Wed, May 12, 2010 at 10:15:46PM +0400, Anton Vorontsov wrote:
>> > We need to create attributes with different modes across devices.
>> > We can do this by modifying attr.mode between device_create_file
>> > invocations, but that is racy in case of globally defined attrs.
>> >
>> > Luckily, there's sysfs_add_file_mode() function that seems to do
>> > exactly what we want, and if we use it, we don't need any locks
>> > to avoid races. Though, it isn't exposed via device-drivers core
>> > API.
>>
>> But you race the creation of the device notifying userspace, and then
>> the file being created, right?
>
> Yep, you've raised that question once, like 3 years ago. :-)
>
> http://lkml.org/lkml/2007/4/11/452
> http://lkml.org/lkml/2007/4/12/144
>
> In short: we can't use attr groups since the attributes creation
> is conditional. And we especially don't want to use the attr groups
> for attrs with different modes. But it's not a problem, because...

Groups have a filter callback for every member, to decide if the
attribute should be created or not.

Kay
