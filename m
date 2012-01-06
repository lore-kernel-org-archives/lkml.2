Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902Ab2AFA0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:26:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2AFA0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:26:45 -0500
Message-ID: <4F063FC0.8000907@gmail.com>
Date: Thu, 05 Jan 2012 19:26:40 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: leonid.moiseichuk@nokia.com
CC: kosaki.motohiro@gmail.com, gregkh@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, penberg@kernel.org,
        aarcange@redhat.com, riel@redhat.com, mel@csn.ul.ie,
        rientjes@google.com, dima@android.com, rebecca@android.com,
        san@google.com, akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related
 changes in MM
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com> <20120104195612.GB19181@suse.de> <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Android OOM (AOOM) is a different thing. Briefly Android OOM is a safety belt,
>but I try to introduce look-ahead radar to stop before hitting wall.

You explained why we shouldn't merge neither you nor android notification patches.
Many embedded developers tried to merge their own patch and claimed "Hey! my patch
is completely different from another one". That said, their patches can't be used
each other use case, just for them.

Systemwide global notification itself is not bad idea. But we definitely choose
just one implementation. thus, you need to get agree with other embedded people.

Again, lowmemorykiller.c should be dropped too.


>  UsedMemory = (MemTotal - MemFree - Buffers - Cached - SwapCached) +
>                                               (SwapTotal - SwapFree)

If you spent a few time to read past discuttion, you should have understand your fomula
is broken and unacceptable. Think, mlocked (or pinning by other way) cache can't be
discarded. And, When system is under swap thrashing, userland notification is
useless. I don't think you tested w/ swap environment heavily.

While you are getting stuck to make nokia specific feature, I'm recommending you
maintain your local patch yourself.

