Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2LSXB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:01:59 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:39832 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2LSXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:01:48 -0500
Message-ID: <50D24687.3060706@ahsoftware.de>
Date: Wed, 19 Dec 2012 23:58:15 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121002 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vincent Palatin <vpalatin@chromium.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org> <20121218164659.a3d3655a.akpm@linux-foundation.org> <50D16EA3.8040803@ahsoftware.de> <20121218234543.786a2211.akpm@linux-foundation.org> <50D1730D.7010108@ahsoftware.de> <20121219002722.87438a08.akpm@linux-foundation.org> <50D180E6.3010305@ahsoftware.de> <20121219143725.3f49598c.akpm@linux-foundation.org>
In-Reply-To: <20121219143725.3f49598c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.12.2012 23:37, schrieb Andrew Morton:

> I think I'll do this:
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: revert "rtc: recycle id when unloading a rtc driver"

Thanks a lot, I just haven't seen the stuff got broken with 3.7 as I
haven't played much with RTCs before (just used them). So I didn't
looked at the git history and fixed it myself just to find out Lothar
already had send a patch. ;)

And for the symmetrie between register/unregister (moving
ida_simple_remove() from release() to unregister()) I'm not exactly sure
if that wouldn't break something. Also it looks like anything which
still would use the ID will fail after unregister (because unregister
cleans up a lot), I'm not quite sure. So just reverting it looks like a
save bet.

Regards,

Alexander
