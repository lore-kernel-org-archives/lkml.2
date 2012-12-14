Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2LNFnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:43:46 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52860 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2LNFnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:43:45 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 21:43:23 -0800
Message-ID: <CALCETrUf6ZPfXuFsZD32w76CQsrqg42_75cmqeTa9jW+in=41A@mail.gmail.com>
Subject: percpu allocation failures in kvm
To: linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.7.0 + irrelevant patches, I get this on boot.  I've seen it on
and off on earlier kernels, I think (although I'm not currently
getting it on 3.5).

[   10.230054] PERCPU: allocation failed, size=304 align=32, alloc
from reserved chunk failed
[   10.230059] Pid: 1026, comm: modprobe Tainted: G        W    3.7.0-ama+ #5
[   10.230060] Call Trace:
[   10.230070]  [<ffffffff81129efb>] pcpu_alloc+0x9db/0xa40
[   10.230074]  [<ffffffff810a81ad>] ? find_symbol_in_section+0x4d/0x140
[   10.230077]  [<ffffffff810a8160>] ? finished_loading+0x50/0x50
[   10.230080]  [<ffffffff810a8af0>] ? each_symbol_section+0x30/0x70
[   10.230083]  [<ffffffff810a8b61>] ? find_symbol+0x31/0x60
[   10.230086]  [<ffffffff8112a1f3>] __alloc_reserved_percpu+0x13/0x20
[   10.230089]  [<ffffffff810ab48d>] load_module+0x3ed/0x1b50
[   10.230093]  [<ffffffff81075c3b>] ? __srcu_read_unlock+0x4b/0x70

--Andy
