Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1BRIRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:17:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab1BRIRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:17:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 29172] New: releasing loop on top of other loop leads to deadlock
Date: Fri, 18 Feb 2011 09:16:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        linux-kernel@vger.kernel.org
References: <bug-29172-10286@https.bugzilla.kernel.org/> <20110217131244.bb64711a.akpm@linux-foundation.org>
In-Reply-To: <20110217131244.bb64711a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102180916.42494.arnd@arndb.de>
X-Provags-ID: V02:K0:HgBPZ1N0hc4q2ns73cjMnpfkX1H9TRxREMfLvP+rU9p
 c/qEG23RzEOe4V7WZnQv/H7U7VsapfBOF3dR2BdQUblcNscHkD
 7xXw4DeAlAY4RjQO9xbl79B5zFgOdAuUMhmmzCWWtA5NrWykNk
 sxyRbh13A9b+R5l6XKtAMIzIAK5Z4TmeD72/H0l7DieKUq0tBg
 lOHxYRWek//gMha3yA9JA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, Andrew Morton wrote:
> On Tue, 15 Feb 2011 10:00:57 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=29172
> 
> post-2.6.37 deadlock in loop.  I'd agree with the reporter that Arnd might be involved ;)

Yes, sounds right, we should fix it and get the fix into stable.

This comes from an automated conversion that was done under the assumption that
it cannot break from making the locking stricter. A related bug happened in the
nbd driver, and I think the solution here should also be to remove the new
mutex. Upon closer review of the code, I cannot see any reason why it would
actually be needed: there is no global data to be protected and all device
specific data is protected by another mutex.

	Arnd
