Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2K2TLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:11:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:24113 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2K2TLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:11:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="226786996"
From: Andi Kleen <andi@firstfloor.org>
To: Prasad Koya <prasad.koya@gmail.com>
Cc: dzickus@redhat.com, aarcange@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmalloc_sync_all(), 64bit kernel, patches 9c48f1c629ecfa114850c03f875c6691003214de, a79e53d85683c6dd9f99c90511028adc2043031f
References: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
Date: Thu, 29 Nov 2012 11:11:28 -0800
In-Reply-To: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
	(Prasad Koya's message of "Mon, 26 Nov 2012 15:06:53 -0800")
Message-ID: <m2wqx4fcm7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prasad Koya <prasad.koya@gmail.com> writes:

> Hi
>
> Before going into crashkernel, nmi_shootdown_cpus() calls
> register_die_notifier(), which calls vmalloc_sync_all(). I'm seeing
> lockup in sync_global_pgds() (init_64.c). From 3.2 and up,
> register_die_notifier() is replaced with register_nmi_handler() (patch
> 9c48f1c629ecfa114850c03f875c6691003214de), which doesn't call
> vmalloc_sync_all(). Is it ok to skip vmalloc_sync_all() in this path?

Yes it's ok for this case. vmalloc_sync_all is only needed when the
notifier is in freshly loaded module code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
