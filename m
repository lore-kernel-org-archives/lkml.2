Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2CAWKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:10:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab2CAWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:10:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/6] Remove tty_lock from the console drivers
Date: Thu, 1 Mar 2012 22:10:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
In-Reply-To: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012210.19222.arnd@arndb.de>
X-Provags-ID: V02:K0:szAu4koYP6HGzYC5KSIHuyRsDemRUN1PeHpVmMFzGCo
 FzyE2vmwGyzYoWCYUOUNyhBhu5NGtZPqP2/n/dtV1V/ogxletB
 Lh0vv9SvK6MyUtMYjbwtbxvvAyZDB/khZmxCGS0OH3AjNgDPz2
 37sGbhfdohP5T+5EYr8KFX5V/kS0MfQc1gNu3x1d/zU36cCgmN
 cXfWr7OnzP2M34QiDtAjXSzJWnkpAa4ScTZUh0E5biaDtlnZ0p
 GPXeiIXhO+DvVsf7ZOhXvXl9nYQkcX/4jFYL06JCZktOowdtWD
 kgR+6qIZy8Ioh5CBcqk5W+pZNndsMYpdmeyywRpfFPNvcFA7NB
 ImklGjk5eGCmi5NhvmOU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Alan Cox wrote:
> 
> This needs a fair bit of testing and a bit of review wouldn't go amiss, but
> it does drive the tty_lock() mess out of the console and correct chunks of
> console locking in the process.

I've spent an hour looking at the patches and trying to understand the code
paths you touch.  The use of console_lock for more stuff than it's currently
used for is slightly worrying, mostly because it's still an old-style
semaphore and not covered by lockdep because of that, which might make testing
harder, but it also seems to be the logical thing to do as you write.

Other than that and the VT_WAITEVENT issue that Jiri pointed out, nothing
else caught my eye, it all looks good.

	Arnd
