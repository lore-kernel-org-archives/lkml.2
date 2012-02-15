Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab2BONrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:47:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491Ab2BONrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:47:22 -0500
Message-ID: <4F3BB763.9080006@redhat.com>
Date: Wed, 15 Feb 2012 15:47:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Rob Earhart <earhart@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com>	<4F2E80A7.5040908@redhat.com>	<CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>	<4F3025FB.1070802@codemonkey.ws>	<4F31132F.3010100@redhat.com> <4F31408F.80901@codemonkey.ws> <4F314B2A.4000709@redhat.com> <4F314F2C.4040100@codemonkey.ws>
In-Reply-To: <4F314F2C.4040100@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 06:19 PM, Anthony Liguori wrote:
>> Ah. But then ioeventfd has that as well, unless the other end is in
>> the kernel too.
>
>
> Yes, that was my point exactly :-)
>
> ioeventfd/mmio-over-socketpair to adifferent thread is not faster than
> a synchronous KVM_RUN + writing to an eventfd in userspace modulo a
> couple of cheap syscalls.
>
> The exception is when the other end is in the kernel and there is
> magic optimizations (like there is today with ioeventfd).

vhost seems to schedule a workqueue item unconditionally.

irqfd does have magic optimizations to avoid an extra schedule.

-- 
error compiling committee.c: too many arguments to function

