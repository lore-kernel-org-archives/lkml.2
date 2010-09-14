Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0INSbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:31:49 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:42995 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0INSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:31:48 -0400
Message-ID: <4C8FBF8E.3060503@msgid.tls.msk.ru>
Date: Tue, 14 Sep 2010 22:31:42 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Whitcroft <apw@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: should 32 bit processes be PER_LINUX32
References: <1284480057-18120-1-git-send-email-apw@canonical.com> <4C8FBCCA.6060001@zytor.com>
In-Reply-To: <4C8FBCCA.6060001@zytor.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14.09.2010 22:19, H. Peter Anvin wrote:
> On 09/14/2010 09:00 AM, Andy Whitcroft wrote:
>> While testing an x86 64 bit kernel on 32 bit userspace I noticed that I
[...]

Folks, while we're at it, can we also fix the ADDR_LIMIT_3GB personality?
With all current kernels it just does not work, returning EINVAL to the
second execve() call.  It never worked from within a 32bit process, but
that at least can be worked around by introducing a small 64bit helper.
Now that helper does not work too.

Or just remove it altogether, to stop confusing people... :)

(We finally moved our legacy application from oracle8 (which only exist
in 32bit for linux) to oracle10, so this problem has no relevance for
us anymore.  Before it were quite problematic...)

Thanks!

/mjt
