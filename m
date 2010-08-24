Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0HXHml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:42:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45685 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0HXHmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kvsQKDm3vVpHyOfVqFj2Z4TiPcj095v9blM91ycP5k8wsb9nMcH56IOkEJio/DRP/2
         TD3u72L1D4faKhufzRIjnZyxOKXkb/k1GAVp1KSv7ee1o+ej67nX5YeAym81WXAiprcr
         g1vFUDhLoGbysqucKfxHV8UdSQpaklINMg+8I=
Message-ID: <4C7376BE.5040006@gmail.com>
Date: Tue, 24 Aug 2010 09:37:34 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008191823.57915.stephan.diestelhorst@amd.com> <4C72639C.6090108@gmail.com> <201008232058.33542.rjw@sisk.pl>
In-Reply-To: <201008232058.33542.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 08:58 PM, Rafael J. Wysocki wrote:
> On Monday, August 23, 2010, Tejun Heo wrote:
>> Hello, sorry about the delay.
>>
>> On 08/19/2010 06:23 PM, Stephan Diestelhorst wrote:
>>> It says "max_performance", I have not touched anyhting. So it has been
>>> like that all the time. Would this explain why your patch did not show
>>> the debug printout?
>>
>> Hmm... okay.  Yeah, if you haven't been using IPM at all, there won't
>> be any debug messages but at the same time the posted patch should
>> have had the same effect as Rafael's patch as IPM path isn't traveled
>> at all.  Can you please check the followings?
>>
>> * You're actually running the correct patched kernel and modules.  It
>>   probably is a good idea to add a printk message.  ie. Apply the
>>   patch and add a printk() in ata_host_request_pm() in libata-core.c
>>   and make sure the debug messages appears.
>>
>> * Rafael's patch actually fixes the problem.  If you haven't been
>>   using IPM at all, Rafael's patch and mine should behave exactly the
>>   same (ie. no IPM operation at all during suspend/resume).  It could
>>   be that you're seeing a different issue.
>>
>> Rafael, can you please test my patch and see how your case behaves?
> 
> This one: http://lkml.org/lkml/2010/8/5/328 ?

Yeap, that one.  I can prep a test git branch if necessary.

Thanks.

-- 
tejun
