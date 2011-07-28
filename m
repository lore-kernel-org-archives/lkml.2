Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1G1LZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:25:40 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36127 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1G1LZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:25:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110728101755.GH2622@htj.dyndns.org>
References: <1311681033.1325.4.camel@mop> <20110728101755.GH2622@htj.dyndns.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 28 Jul 2011 13:18:18 +0200
Message-ID: <CAPXgP13=_UoOZnwBMordFxiMiyfu+nF685+qk01zoy4jDrv=Pw@mail.gmail.com>
Subject: Re: [PATCH] loop: add management interface for on-demand device allocation
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 12:17, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jul 26, 2011 at 01:50:30PM +0200, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: loop: add management interface for on-demand device allocation
>>
>> Loop devices today have a fixed pre-allocated number of usually 8.
>> The number can only be changed at init time. To find a free device
>> to use, /dev/loop%i needs to be scanned and all devices need to be
>> opened.
>
> It generally looks good to me but I really hope it were split into
> multiple patches.  I think it's a bit too big and doing too many
> different things.  Can you please split it up?

Hmm, split into what? Like splitting the loop-control stuff off? The
rest can't really be split I guess, because all the linked lists need
to be converted to idr at once.

>> +static int loop_lookup(struct loop_device **lo, int nr);
>> +static int loop_add(struct loop_device **lo, int nr);
>
> Also, can't these return loop_device * and ERR_PTR() value on errors?

I think ERR_PTR is a nasty hack and looks ugly, and stuff should
return only pointers when the retuned errno can only ever be -ENOMEM,
like on malloc(). :)

Kay
