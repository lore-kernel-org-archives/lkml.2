Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0IFMoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:44:32 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36393 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0IFMob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sGlAzb3YZK5gI5fGYfbf4hsdsNBB322wjJIm8g/hyHgyUrGqFUfGDVQZ8WRIGloasm
         cLBhxEI1dIPCrxhu7evXVkyKFgbFNHTu5147oDHnNMg2gJGpyUmAgfW/re9LTVm8AFys
         2Sh4dssrgv8XvC540yV59p7oj9lVfBJk8TXeU=
MIME-Version: 1.0
In-Reply-To: <4C8111A5.4050204@goop.org>
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
	<20100903122253.GL2804@reaktio.net>
	<4C8111A5.4050204@goop.org>
Date: Mon, 6 Sep 2010 13:44:29 +0100
Message-ID: <AANLkTi=wchjShvRd9vP6o0NSw1UEqmYENqkjL=+8kasi@mail.gmail.com>
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
From: Doug Neal <dneallkml@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 4:17 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>  On 09/03/2010 05:22 AM, Pasi Kärkkäinen wrote:
>> On Wed, Sep 01, 2010 at 03:17:25PM +0100, Doug Neal wrote:
>>> Hello all,
>>>
>>> I believe I have found a bug in the I/O scheduler which results in
>>> access to a block device being blocked indefinitely.
>>>
>>> The setup:
>>>  * Xen dom0 version 3.4.2.
>>>  * domU: Ubuntu 10.04, x86_64, with kernel 2.6.32.15+drm33.5.
>>>  * Paravirtual disks and network interfaces.
>>>  * Root filesystem on /dev/xvdb1
>>>  * A scratch filesystem for the purposes of my tests on /dev/xvda
>>> mounted on /mnt
>>>  * Both filesystems are ext3, formatted and mounted with defaults
>>>  * XVBDs are backed by LVM on top of an iSCSI SAN in the dom0.
>>>
>> Hmm.. recently there was some patches to the Xen block device frontend driver
>> (sent to lkml). Maybe you should try if those make a difference?
>>
>> Jeremy: What do you think?
>
> I think this is more likely to be related to the lost interrupt bug
> which I sent fixes up for last week ("xen: use percpu interrupts for
> IPIs and VIRQs" and "xen: handle events as edge-triggered").
>
> Doug, as a workaround, try disabling irqbalanced.
>
> Thanks,
>    J

Jeremy,

That seems to be doing the trick - thanks! Will see about trying the
patches as well.

Doug
