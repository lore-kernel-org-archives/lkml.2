Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2DXAVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:21:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43624 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2DXAVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:21:50 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 20:21:50 EDT
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <4F95828A.8050403@xenotime.net> (Randy Dunlap's message of "Mon,
	23 Apr 2012 09:25:46 -0700")
References: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>
	<4F95828A.8050403@xenotime.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Mon, 23 Apr 2012 17:25:49 -0700
Message-ID: <m1obqirn5e.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19IforSrn7laSBNR5lMwbG0yg+4wf+ErUs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  8.5 XMNoUri_00 BODY: domains not in uri format
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: **
Subject: [PATCH] net ax25: Fix the build when sysctl support is disabled.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Randy Dunlap <rdunlap@xenotime.net> reported:

> On 04/23/2012 12:07 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120420:
>
>
> include/net/ax25.h:447:75: error: expected ';' before '}' token
>
> static inline int ax25_register_dev_sysctl(ax25_dev *ax25_dev) { return 0 };
> static inline void ax25_unregister_dev_sysctl(ax25_dev *ax25_dev) {};
>
> First function:  move ';' inside braces.
> Second function:  drop the ';'.

Put the semicolons where it makes sense.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---

Resent to include David Miller.

 include/net/ax25.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8a7a122..5d23521 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -444,8 +444,8 @@ extern void ax25_uid_free(void);
 extern int ax25_register_dev_sysctl(ax25_dev *ax25_dev);
 extern void ax25_unregister_dev_sysctl(ax25_dev *ax25_dev);
 #else
-static inline int ax25_register_dev_sysctl(ax25_dev *ax25_dev) { return 0 };
-static inline void ax25_unregister_dev_sysctl(ax25_dev *ax25_dev) {};
+static inline int ax25_register_dev_sysctl(ax25_dev *ax25_dev) { return 0; }
+static inline void ax25_unregister_dev_sysctl(ax25_dev *ax25_dev) {}
 #endif /* CONFIG_SYSCTL */
 
 #endif
-- 
1.7.2.5

