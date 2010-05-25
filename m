Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0EYEns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 00:43:48 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:59710 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0EYEnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 00:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <4BFAC0B0.2060701@signal11.us>
References: <4BFAC0B0.2060701@signal11.us>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 25 May 2010 06:43:30 +0200
Message-ID: <AANLkTikDHib2QiQ51cJztYGxORojxo5PEwOGXvS5vCJ1@mail.gmail.com>
Subject: Re: [RFC] User Guide for Sysfs and libudev
To: Alan Ott <alan@signal11.us>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 20:08, Alan Ott <alan@signal11.us> wrote:
> Several weeks ago I had need of libudev, and was unable to find very
> much documentation for it on the web.
>
> I have created a guide on how to use libudev, which also provides some
> background information on /dev, Sysfs, and why this kind of thing is needed.
>
> Please check it out and provide comments, as I'm sure there are things
> which I have gotten wrong or omitted.
>
> The guide can be found here:
>    http://www.signal11.us/oss/udev/

Enumeration and monitoring should be in one example, I guess -- that's
what people are supposed to do today. Before starting to enumerate,
software should subscribe to events. This makes the handle
coldplug/hotplug properly, makes it handle duplicate events properly,
and all other sorts of cases, which software should handle today.

Also "change" is not necessarily a "property" change, it can be any
event, that a device has changed its state, it will only in  a few
cases be visible in /sys. The most prominent example is "media
changed" event for SCSI devices, and we forward them to the block
device. There will never change anything in /sys before or after the
event.

Kay
