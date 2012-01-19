Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab2ASCUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:20:13 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58629 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755762Ab2ASCUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:20:11 -0500
Date: Wed, 18 Jan 2012 18:20:05 -0800
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Message-ID: <20120119022005.GG21533@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
 <20120118213638.GA21533@google.com>
 <20120119014727.GG29242@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119014727.GG29242@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lennart, Li.

Two things.

* Probably I'm missing something but isn't the systemd cgroup
  hierarchy already managed by systemd?  If so, I don't see how
  managing tmpfs on the side would noticeably make things more
  fragile.  It would take a bit more care after, for example, restart
  but it shouldn't be too complex, no?

* FS attributes already being used for userland information seems like
  a good argument, but we shouldn't add separate specialized xattr
  implementation to different pseudo filesystems.  For it to be
  acceptable, it should be a libfs thing easily applicable to any
  pseudo FS and definitely shouldn't be using kmem for storage.

Thanks.

-- 
tejun
