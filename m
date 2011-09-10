Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab1IJDbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 23:31:40 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53670 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab1IJDbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 23:31:39 -0400
Date: Fri, 9 Sep 2011 23:31:29 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-X220
To: Yinghai Lu <yinghai.lu@oracle.com>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: MTRR allocation failure
In-Reply-To: <CAE9FiQX5ZL5LbQtVfbKCvbJoPvkOhvmCtsvEXAJZU1+48R9_WQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109092327210.1672@parag-X220>
References: <alpine.DEB.2.02.1109092042540.11756@parag-X220> <CAE9FiQX5ZL5LbQtVfbKCvbJoPvkOhvmCtsvEXAJZU1+48R9_WQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Sep 2011, Yinghai Lu wrote:
> 
> your BIOS create one new WP entry. so mtrr sanitizer is not triggered...
> 
> Maybe you can just delete first entry before you load drm?

Thank you! That fixes the issue for me.

If anyone else has extra/write-protect entry in /proc/mtrr that can be 
deleted - here is what you can drop in /etc/modprobe.d/drm.conf -

# Free up a mtrr entry for drm
install drm /sbin/fix-mtrr-local.sh && { /sbin/modprobe --ignore-install $CMDLINE_OPTS drm ; }

/sbin/fix-mtrr-local.sh

#modify the grep arg and disable= to your needs
#!/bin/sh

grep write-protect /proc/mtrr

if [ $? -eq 0 ]; then
echo "disable=0" > /proc/mtrr
fi
exit 0
