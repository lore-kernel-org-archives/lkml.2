Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1ISDcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:32:54 -0400
Received: from void.printf.net ([89.145.121.20]:42499 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1ISDcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:32:52 -0400
From: Chris Ball <cjb@laptop.org>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: RFC : mmc : boot partition is set as a read-write.
References: <CAKYAXd8xd3sCi0CCOH6Y3AR2J2iuDQispCnt0D2mksiAWr=rgw@mail.gmail.com>
Date: Sun, 18 Sep 2011 23:32:46 -0400
In-Reply-To: <CAKYAXd8xd3sCi0CCOH6Y3AR2J2iuDQispCnt0D2mksiAWr=rgw@mail.gmail.com>
	(NamJae Jeon's message of "Mon, 19 Sep 2011 12:10:28 +0900")
Message-ID: <m2vcsp2om9.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Sep 18 2011, NamJae Jeon wrote:
> mmc : boot partition is set as a read-write.
>
> There is a case that user directly update boot partition through mmcblk0boot0,1.
> However, the current boot partition is set as a read-only.
> I suggest that boot partition is set as a read-write if there is no
> reason that it should be read-only.

There is a reason.

Documentation/mmc/mmc-dev-parts.txt:

MMC Boot Partitions
===================

Read and write access is provided to the two MMC boot partitions. Due to
the sensitive nature of the boot partition contents, which often store
a bootloader or bootloader configuration tables crucial to booting the
platform, write access is disabled by default to reduce the chance of
accidental bricking.

To enable write access to /dev/mmcblkXbootY, disable the forced read-only
access with:

echo 0 > /sys/block/mmcblkXbootY/force_ro

==
- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
