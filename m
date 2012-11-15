Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768360Ab2KOQCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:02:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33566 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768293Ab2KOQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:02:43 -0500
MIME-Version: 1.0
In-Reply-To: <20121115144404.GA7306@mtj.dyndns.org>
References: <1352982197-7447-1-git-send-email-dh.herrmann@googlemail.com>
	<20121115144404.GA7306@mtj.dyndns.org>
Date: Thu, 15 Nov 2012 17:02:42 +0100
Message-ID: <CANq1E4QFj2PuMJkFcS+zs5U0kMD6Anm0Q4RXOuJyFQA9zrXSGw@mail.gmail.com>
Subject: Re: [PATCH v2] cuse: do not register multiple devices with the same name
From: David Herrmann <dh.herrmann@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

On Thu, Nov 15, 2012 at 3:44 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Nov 15, 2012 at 01:23:17PM +0100, David Herrmann wrote:
>> We do not check whether we already registered a CUSE device with a given
>> name so we might end up with two devices with the same name. Sysfs will
>> then complain as it cannot create suitable directories.
>>
>> This patch makes the init-command fail if there is already a device with
>> the given name. To avoid race-conditions, we protect the whole
>> registration with a mutex now.
>>
>> Following the sysfs warnings when registering two devices with the same
>> name:
> ...
>> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> But it probably would be better to separate out mutex conversion as a
> separate patch.

Thanks for reviewing it again. I noticed the for-loop doesn't check
all registered devices but only the devices in the same list-head.
Luckily in my test-cases this was true.

I will resend a v3 where I split this into two patches and correctly
traverse the array and every list.

Thanks
David
