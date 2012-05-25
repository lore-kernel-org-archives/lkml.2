Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2EYJZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:25:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51259 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2EYJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:25:55 -0400
Subject: Re: [RFC PATCH 0/4 V2] introduce: livedump
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 11:25:42 +0200
Message-ID: <1337937942.9783.170.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 18:12 +0900, YOSHIDA Masanori wrote:
> Live Dump is based on Copy-on-write technique. Basically processing is
> performed in the following order.
> (1) Suspends processing of all CPUs.
> (2) Makes pages (which you want to dump) read-only.
> (3) Resumes all CPUs
> (4) On page fault, dumps a page including a fault address.

Suppose a PF is in progress when all this happens, you mark all RO, then
an NMI happens, from the NMI context we'll generate another PF to update
a vmap area, this will again PF because you mucked about and marked
things RO.

You're now at 3 PFs, which is instant reboot.

I don't think this is going to work.

