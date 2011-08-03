Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1HCNpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:45:10 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:58093 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab1HCNpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:45:08 -0400
From: Richard Weinberger <richard@nod.at>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
Date: Wed, 3 Aug 2011 15:45:00 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        manuel.lauss@googlemail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, segoon@openwall.com, gregkh@suse.de
References: <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org> <20110803131323.GC2773@nautilus.holoscopio.com> <CAPXgP12Ocdcmh7USsPv+WzYFTSh3EFi++q7YWop-XEUjrXfQAw@mail.gmail.com>
In-Reply-To: <CAPXgP12Ocdcmh7USsPv+WzYFTSh3EFi++q7YWop-XEUjrXfQAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108031545.01122.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 03 August 2011 15:33:27 Kay Sievers wrote:
> On Wed, Aug 3, 2011 at 15:13, Thadeu Lima de Souza Cascardo
> 
> <cascardo@minaslivre.org> wrote:
> > As Marc Zyngier has pointed out, the culprit is driver_init, which
> > calls devices_init. I'd say other calls from driver_init also call into
> > kset and kobject, which will dispatch uevent helper.
> > 
> > I tried to reproduce the problem using UML and only was successful after
> > setting CONFIG_UEVENT_HELPER_PATH. I guess we could obsolete this
> > feature and plan its removal soon. Is anybody still using this?
> 
> Forking binaries from the kernel for frequent events is something
> fundamentally wrong to do. It is not even rate-limited or has any
> upper bounds. It is known to create out-of-memory situations on
> machines with many devices and tiny RAM. Configs that virtualizations
> with many guests use pretty often. They can not even bootup with
> /sbin/hotplug enabled then.
> 
> It would be nice to remove that broken thing, no common system or
> distro uses it since quite some years now. But I wouldn't be surprised
> if some people still use it for whatever hack they need locally.
> 

True.

I'll remove CONFIG_UEVENT_HELPER_PATH from UML's defconfig.

Thanks,
//richard
