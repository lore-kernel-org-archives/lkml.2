Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab0G2Nri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:47:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64152 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab0G2Nrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <1280410435-7017-1-git-send-email-mbroz@redhat.com>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 29 Jul 2010 15:47:21 +0200
Message-ID: <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com>
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
To: Milan Broz <mbroz@redhat.com>
Cc: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org,
        kzak@redhat.com, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 15:33, Milan Broz <mbroz@redhat.com> wrote:
> Create /sys/block/loopX/loop directory and provide these attributes:
>  - backing_file
>  - autoclear
>  - offset
>  - sizelimit
>
> To be used in util-linux-ng (and possibly elsewhere like udev rules)
> where code need to get loop attributes from kernel (and not store
> duplicate info in userspace).

Isn't it that the loop attributes are created _after_ the loopdev is
registered? That would make it hard to use these attributes from udev,
as the event is already running while they are created.

Kay
