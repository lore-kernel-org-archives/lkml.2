Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0HJLGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:06:44 -0400
Received: from peer.zerties.org ([188.40.33.175]:32904 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab0HJLGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:06:39 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: felipe.balbi@nokia.com
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev\@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 2/4] arch/frv: Removing dead HEARTBEAT config option
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<fafef93430b45ac966abc77ed061647af2814873.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<20100810093537.GC22436@nokia.com>
Date: Tue, 10 Aug 2010 13:06:26 +0200
In-Reply-To: <20100810093537.GC22436@nokia.com> (Felipe Balbi's message of
	"Tue, 10 Aug 2010 12:35:38 +0300")
Message-ID: <86zkwuwwul.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Felipe Balbi <felipe.balbi@nokia.com> writes:
> On Tue, Aug 10, 2010 at 11:11:13AM +0200, ext Christian Dietrich wrote:
>>diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
>>index 0ddbbae..e86df6c 100644
>>--- a/arch/frv/kernel/time.c
>>+++ b/arch/frv/kernel/time.c
>>@@ -66,12 +66,6 @@ static irqreturn_t timer_interrupt(int irq, void *dumm=
y)
>>
>> 	do_timer(1);
>>
>>-#ifdef CONFIG_HEARTBEAT
>
> should you instead change to CONFIG_LEDS_TRIGGER_HEARTBEAT ?

I didn't know of this config option, but i think this would be better. I
attached a patch for it.

greetz didi
--=20
(=CE=BB x . x x) (=CE=BB x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-arch-frv-Rename-dead-HEARTBEAT-config-option.patch

>From 36cfe416d7b099097ed3f37bb62134c674fc68ce Mon Sep 17 00:00:00 2001
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Date: Tue, 10 Aug 2010 13:02:30 +0200
Subject: [PATCH] arch/frv: Rename dead HEARTBEAT config option

Because CONFIG_HEARTBEAT isn't defined for the frv arch, this block
would be dead. As suggested by Felipe Balbi CONFIG_HEARTBEAT was
replaced by CONFIG_LEDS_TRIGGER_HEARTBEAT.
---
 arch/frv/kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..d8fff7e 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -66,11 +66,11 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 
 	do_timer(1);
 
-#ifdef CONFIG_HEARTBEAT
+#ifdef CONFIG_LEDS_TRIGGER_HEARTBEAT
 	static unsigned short n;
 	n++;
 	__set_LEDS(n);
-#endif /* CONFIG_HEARTBEAT */
+#endif /* CONFIG_LEDS_TRIGGER_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
 
-- 
1.7.0.4


--=-=-=--
