Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1HCNdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:33:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57158 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1HCNdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110803131323.GC2773@nautilus.holoscopio.com>
References: <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org> <20110803131323.GC2773@nautilus.holoscopio.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 3 Aug 2011 15:33:27 +0200
Message-ID: <CAPXgP12Ocdcmh7USsPv+WzYFTSh3EFi++q7YWop-XEUjrXfQAw@mail.gmail.com>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
Cc: linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        manuel.lauss@googlemail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, segoon@openwall.com, richard@nod.at,
        gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 15:13, Thadeu Lima de Souza Cascardo
<cascardo@minaslivre.org> wrote:
> As Marc Zyngier has pointed out, the culprit is driver_init, which
> calls devices_init. I'd say other calls from driver_init also call into
> kset and kobject, which will dispatch uevent helper.
>
> I tried to reproduce the problem using UML and only was successful after
> setting CONFIG_UEVENT_HELPER_PATH. I guess we could obsolete this
> feature and plan its removal soon. Is anybody still using this?

Forking binaries from the kernel for frequent events is something
fundamentally wrong to do. It is not even rate-limited or has any
upper bounds. It is known to create out-of-memory situations on
machines with many devices and tiny RAM. Configs that virtualizations
with many guests use pretty often. They can not even bootup with
/sbin/hotplug enabled then.

It would be nice to remove that broken thing, no common system or
distro uses it since quite some years now. But I wouldn't be surprised
if some people still use it for whatever hack they need locally.

Kay
