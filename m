Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1HSK0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:26:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34177 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1HSK0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <m17h69sr03.fsf@fess.ebiederm.org>
References: <4E4CDF44.5080109@redhat.com> <m17h69sr03.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 19 Aug 2011 12:26:30 +0200
Message-ID: <CAPXgP13KeTnBD+hgf_hM55EiQFsYCxmCwyhRaNZ0rUJpjKK=-g@mail.gmail.com>
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 11:13, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Milan Broz <mbroz@redhat.com> writes:
>> If you run clone() with CLONE_NEWNET (which is chromium using
>> for sanboxing), udev namespace is cloned too (newly registered
>> in uevent_sock_list) and netlink send (except the first in list)
>> fails with -ESRCH.
>>
>> This causes that _every_ call of kobject_uevent_env() return failure.

> That netlink_ broadcast chooses to treat failure to deliver a packet to
> anyone as an error and return -ESRCH is a little peculiar.  In general
> we don't see that error because when you are testing there is at least
> one listener on the netlink socket.  So as a practical matter I think
> we should be ignoring return values of -ESRCH from netlink_broadcast,
> in kobject_uevent_env.

Wouldn't a wrap in netlink_has_listeners() help before we try to send it?

Kay
