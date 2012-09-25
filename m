Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2IYPUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:20:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44486 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2IYPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:20:20 -0400
Date: Tue, 25 Sep 2012 08:20:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Question about dev_uevent_filter
Message-ID: <20120925152016.GG18777@kroah.com>
References: <5061CA27.7060006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061CA27.7060006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 11:13:43PM +0800, Lan Tianyu wrote:
> 
> hi Greg:

[linux-usb added as it concerns them as well]

> 	I find only devices which has bus_type or class can add uevent callback
> and output the uevent information. This is because the dev_uevent_filter just return
> true for these devices. But some device may not have class and bus_type.
> e.g usb endpoint, if we assigned them to usb_bus_type, device core will
> try to create sysfs directory link under /sys/bus/usb. But endpoint sysfs
> directory's name are same for each usb devices.e.g ep_00, every usb device will
> create the endpoint. So in this situation, we can't assign usb endpoint to
> usb_bus_type. So even if uevent callback was added and with some information,
> it still couldn't output anything. Can we add dev->type check in the
> dev_uevent_filter() and return 1 if type exits?

Wait, why do you want a uevent for a USB endpoint?  What is the problem
you are trying to solve here?

greg k-h
