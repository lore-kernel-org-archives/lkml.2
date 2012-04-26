Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2DZNow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:44:52 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:60862 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab2DZNov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:44:51 -0400
Message-ID: <4F995150.4070003@msgid.tls.msk.ru>
Date: Thu, 26 Apr 2012 17:44:48 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru>
In-Reply-To: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.04.2012 17:34, Michael Tokarev wrote:
> This patch introduces a new autofs interface version, v6, which
> is exactly the same as v5 but uses better defined packet structure
> which does not change between architectures or platform bitness.
> Old interface is supported still.

I forgot to mention: this should go on top of revert of the
previous attempt to fix it, ie, after reverting commit
a32744d4abae24572eff7269bc17895c41bd0085.

The change does not break old API on which the workaround
in the automount daemon relies since new sizeof(packet)
will be dividable by 8 and hence the old workaround code
in automount (compiled with new header) will not trigger.

Thanks,

/mjt
