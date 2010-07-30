Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0G3HoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:44:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53977 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0G3HoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100730073704.GH1981@nb.net.home>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 
	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 
	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> 
	<20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> 
	<20100730073704.GH1981@nb.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 30 Jul 2010 09:43:44 +0200
Message-ID: <AANLkTimFov0uUkrWR-MsgETZ9=oHfByHu2q+JOFF5qAS@mail.gmail.com>
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 09:37, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Jul 29, 2010 at 06:07:31PM +0200, Kay Sievers wrote:
>> Sure it does. Sysfs attributes need to be created _before_ uevents are
>> sent out. The current behavior is that all blockdev attributes are
>> safely created before the event is sent.
>
>  Hmm... I see that in add_disk(), the "queue" subdirectory is created
>  after disk registration (the register_disk() calls kobject_uevent()).
>  Is it true?

Might be. Then seems nobody has tried using this stuff from udev. :)

blk_register_queue() probably needs to move to register_disk(), where
the uevent is delayed until all stuff is properly created.

Kay
