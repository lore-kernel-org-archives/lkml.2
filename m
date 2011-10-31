Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1JaJXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:23:10 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4523 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1JaJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:23:08 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4EAE68ED.9070406@broadcom.com>
Date: Mon, 31 Oct 2011 10:22:53 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "David Herrmann" <dh.herrmann@googlemail.com>
cc: "Dan Carpenter" <dan.carpenter@oracle.com>, "Julia Lawall" <julia@diku.dk>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] drivers/hid/hid-roccat.c: eliminate a null
 pointer dereference
References: <1319846297-2985-3-git-send-email-julia@diku.dk>
 <20111029062412.GG14881@longonot.mountain>
 <4EABC937.60600@broadcom.com>
 <CANq1E4QJoM+NYub9hfs3KnL1w212FK0MHo8ez2p1nyGmNVb-=A@mail.gmail.com>
In-Reply-To: <CANq1E4QJoM+NYub9hfs3KnL1w212FK0MHo8ez2p1nyGmNVb-=A@mail.gmail.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=B5E1A116
X-WSS-ID: 62B0B5125IS24622932-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2011 12:53 PM, David Herrmann wrote:
> On Sat, Oct 29, 2011 at 11:36 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 10/29/2011 08:24 AM, Dan Carpenter wrote:
>>> On Sat, Oct 29, 2011 at 01:58:15AM +0200, Julia Lawall wrote:
>>>> diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
>>>> index 2596321..36a28b8 100644
>>>> --- a/drivers/hid/hid-roccat.c
>>>> +++ b/drivers/hid/hid-roccat.c
>>>> @@ -163,14 +163,15 @@ static int roccat_open(struct inode *inode, struct file *file)
>>>>
>>>>      device = devices[minor];
>>>>
>>>> -    mutex_lock(&device->readers_lock);
>>>> -
>>>>      if (!device) {
>>>>              pr_emerg("roccat device with minor %d doesn't exist\n", minor);
>>>> -            error = -ENODEV;
>>>> -            goto exit_err;
>>>> +            kfree(reader);
>>>> +            mutex_lock(&devices_lock);
>>>
>>> Typo.  mutex_unlock() instead of mutex_lock().
>>
>> This is no typo, but simply wrong. Remove the mutex_lock() as we are
>> leaving the function here in error flow.
> 
> No, this one is definitely needed. Its devices_lock, not
> device->readers_lock! And devices_lock is locked before so we need to
> unlock it if we return in this branch.

You are right. I missed that. As usual Dan's eye is sharper ;-)

Gr. AvS


