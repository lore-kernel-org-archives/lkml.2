Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2BCV31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:29:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab2BCV3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:29:25 -0500
Message-ID: <4F2C51A5.1040800@zytor.com>
Date: Fri, 03 Feb 2012 13:29:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Kconfig and toolchain dependencies
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, we don't have a good way to encode toolchain dependencies in
Kconfig.  This makes it hard to add optional features which depend on
newer toolchain features.

If we just add them, then it breaks all*config and randconfig on
platforms with the older toolchains unless the user manually adds
exclusion rules.  This is bad for testing.

It seems relatively straightforward to do if we were to manifest some
CONFIG_ variables based on the target toolchain, e.g.

CONFIG_GCC=0x040601

... and perhaps do other tests.  I suspect we would run the tests less
frequently than what we do right now with the tests embedded in the
Makefile.

Does anyone have a feel for if this would be a good addition, and if so
where it best fits into the chain?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

