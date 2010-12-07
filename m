Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0LGTAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:00:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48873 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0LGTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <20101207183305.GA21802@suse.de>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
 <20101207162755.GA32328@suse.de> <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6>
 <20101207183305.GA21802@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 7 Dec 2010 20:00:36 +0100
Message-ID: <AANLkTinmuxDYU9-zGvWB0mDDuXZEfZnuVxtSYGk62c8P@mail.gmail.com>
Subject: Re: [RFC] bind/unbind uevent
To: Greg KH <gregkh@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 19:33, Greg KH <gregkh@suse.de> wrote:
> On Tue, Dec 07, 2010 at 06:29:37PM +0100, Sebastian Ott wrote:

>> So I'm searching for a trigger when these attributes are created, or
>> in other words when the device is useable, which I think translates to
>> when a driver is bound to this device.
>
> Again, KOBJ_ADD is the correct one.
>
> If your driver is creating sysfs attributes on its own, that's a bug and
> should be fixed.

Sounds a bit like the driver should create its own child device with
its own properties, instead of mangling around with attributes at a
device it binds to.

Sebastian, care to be more specific about the problem and bus in
question. We should avoid new generic events. In some special cases,
sending out 'change' from the driver might be acceptable, but it's
usually not what we would suggest.

Kay
