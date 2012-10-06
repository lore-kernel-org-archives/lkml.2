Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab2JFGTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 02:19:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JFGTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 02:19:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/16] cgroup: fix warning when building without any subsys
Date: Sat, 6 Oct 2012 06:19:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Li Zefan <lizefan@huawei.com>,
        Ben Blum <bblum@andrew.cmu.edu>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-8-git-send-email-arnd@arndb.de> <20121006021451.GA2601@localhost>
In-Reply-To: <20121006021451.GA2601@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210060619.41645.arnd@arndb.de>
X-Provags-ID: V02:K0:xs8KK3XFUyg92DH1XDOEATvN617AB38M2HtLZdvp29Z
 +76TXdx0z8qUUB17ARkwJLcb0Y0dj6xI02+mvOkG3Kz1jKpwGb
 8+oh1L9wbHLA2Adard2ufE1M414ErPBl7Mmt+rJlX/KydFxK0A
 CEUd3+pTzDFYxmza2eQHQMZPYWlCZcS2MVL7iA5DkaL53jMFos
 mRsN0SyokGkc/DTo3yhXpI/xJqKKt/4qAdSs9jQKjyxDZSWQTK
 GEwZ7i8wqiYVW+/cPtCgOEs5jnIrcLXhb65S9d9i7EZdtqS2OP
 ytUPFO4QW5feKHd94Gq46BXKqyEjjxgQBodEcpTDmhGTooA4TU
 RpFCBnr+B19FhMIoeuQU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2012, Tejun Heo wrote:
> On Fri, Oct 05, 2012 at 04:55:21PM +0200, Arnd Bergmann wrote:
> > In a configuration where the base cgroup support is enabled but
> > every single cgroup subsys is turned off, CGROUP_BUILTIN_SUBSYS_COUNT
> > is zero, which causes the sanity check code in cgroup_load_subsys
> > to trigger:
> > 
> >        BUG_ON(ss->subsys_id >= CGROUP_BUILTIN_SUBSYS_COUNT);
> >        BUG_ON(subsys[ss->subsys_id] != ss);
> 
> CGROUP_BUILTIN_SUBSYS_COUNT is already gone in mainline.  I suppose
> this is no longer necessary?

Ah, you are right. I can confirm the problem is gone, and I'll drop
the patch.

	Arnd
