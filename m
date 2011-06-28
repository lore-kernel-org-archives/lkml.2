Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1F1Wv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:51:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65112 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1F1WvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikt08CDJiKNxGF2mKmOhyxHfv21_g@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com> <20110627222121.GD20865@ponder.secretlab.ca>
 <BANLkTikt08CDJiKNxGF2mKmOhyxHfv21_g@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 28 Jun 2011 16:51:01 -0600
X-Google-Sender-Auth: g4lUJkP6-I0gKbv_7cS3Q6TJpuw
Message-ID: <BANLkTim+CemMz7A3J94e1UywCNd0r1SABQ@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:46 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Grant,
>
> On Tue, Jun 28, 2011 at 1:21 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> +static int rpmsg_remove_device(struct device *dev, void *data)
>>> +{
>>> +     struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
>>> +
>>> +     device_unregister(dev);
>>> +
>>> +     kfree(rpdev);
>>
>> put_device() I think.
>
> Don't think so, we get the device handle from device_for_each_child
> here, which doesn't call get_device (unlike device_find_child).

It's not the device_for_each_child() that you're 'putting' back from
here.  Its the original kref initialization when the device was
created.  Once a device is initialized, it must never be directly
kfree()'d.

g.
