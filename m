Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2EKLDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:03:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59843 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2EKLDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <4FACF02B.7070006@broadcom.com>
References: <4FACF02B.7070006@broadcom.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 11 May 2012 13:03:28 +0200
Message-ID: <CAPXgP12qaNm1Vh=8isf2gq=sUW8hOgi_STNfTuOqg5XT4KgwZA@mail.gmail.com>
Subject: Re: in-kernel drivers and firmware loader
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:55 PM, Arend van Spriel <arend@broadcom.com> wrote:
> To my memory (which fails from time to time) you posted a message on
> using the asynchronous API for firmware loading as some drivers were
> blocking on it in the module initialization. So for our driver we
> decoupled the initialization from probe and subsequently the firmware
> request. Assuming this solves the udev issue, but I am currently looking
> into a somewhat related issue with our driver built-in.
>
> I am testing on a PandaBoard which boots a linux kernel without a initrd
> and our device is detected before the root filesystem is mounted. I was
> expecting the async firmware request to get called back immediatly with
> firmware pointer being NULL. The behaviour is slightly different as this
> callback is coming after 60 seconds, which is the timeout. I guess the
> uevent just gets lost without the kernel knowing it. Is that correct?

It's probably sent, but nothing see it because there is no userspace
that would have subscribed.

If udev is started later during bootup, and the coldplug triggers all
events again, the firmware request should be found and be fulfilled by
userspace -- at least that's the theory.

Can you reach the box with a login before the 60 seconds are reached?

Do you see a firmware request (directory) still hanging around in
/sys/class/firmware/ ?

Kay
