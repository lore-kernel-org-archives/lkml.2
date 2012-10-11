Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2JKHQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:16:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37854 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2JKHP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:15:59 -0400
Date: Thu, 11 Oct 2012 00:15:50 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 60/84] r8169: fix wake on lan setting for non-8111E.
Message-ID: <20121011071550.GA27313@elie.Belkin>
References: <20121011015417.017144658@linuxfoundation.org>
 <20121011015427.889586553@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011015427.889586553@linuxfoundation.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Greg Kroah-Hartman wrote:

> commit d4ed95d796e5126bba51466dc07e287cebc8bd19 upstream.
>
> Only 8111E needs enable RxConfig bit 0 ~ 3 when suspending or
> shutdowning for wake on lan.

Sounds sensible to me, but I haven't reviewed this --- e.g., I
don't know what symptoms this addresses or what model they were
experienced on.

Here's a patch to remove the reviewed-bys that seem to have been
added by mistake.

Thanks,
Jonathan

-- >8 --
Subject: queue-3.0: remove reviewed-by on patches I haven't reviewed

---
 ...ater-require-bit-0x20-to-be-set-in-config2-for-pme-signaling.patch |    1 -
 .../r8169-call-netif_napi_del-at-errpaths-and-at-driver-unload.patch  |    1 -
 queue-3.0/r8169-config1-is-read-only-on-8168c-and-later.patch         |    1 -
 queue-3.0/r8169-don-t-enable-rx-when-shutdown.patch                   |    1 -
 queue-3.0/r8169-expand-received-packet-length-indication.patch        |    1 -
 queue-3.0/r8169-fix-config2-msienable-bit-setting.patch               |    1 -
 queue-3.0/r8169-fix-unsigned-int-wraparound-with-tso.patch            |    1 -
 queue-3.0/r8169-fix-wake-on-lan-setting-for-non-8111e.patch           |    1 -
 .../r8169-increase-the-delay-parameter-of-pm_schedule_suspend.patch   |    1 -
 queue-3.0/r8169-jumbo-fixes.patch                                     |    1 -
 queue-3.0/r8169-missing-barriers.patch                                |    1 -
 queue-3.0/r8169-remove-erroneous-processing-of-always-set-bit.patch   |    1 -
 queue-3.0/r8169-runtime-resume-before-shutdown.patch                  |    1 -
 13 files changed, 13 deletions(-)

diff --git a/queue-3.0/r8169-8168c-and-later-require-bit-0x20-to-be-set-in-config2-for-pme-signaling.patch b/queue-3.0/r8169-8168c-and-later-require-bit-0x20-to-be-set-in-config2-for-pme-signaling.patch
index b4d1b9d4..9dd53b4e 100644
--- a/queue-3.0/r8169-8168c-and-later-require-bit-0x20-to-be-set-in-config2-for-pme-signaling.patch
+++ b/queue-3.0/r8169-8168c-and-later-require-bit-0x20-to-be-set-in-config2-for-pme-signaling.patch
@@ -12,7 +12,6 @@ The new 84xx stopped flying below the radars.
 
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
 Cc: Hayes Wang <hayeswang@realtek.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-call-netif_napi_del-at-errpaths-and-at-driver-unload.patch b/queue-3.0/r8169-call-netif_napi_del-at-errpaths-and-at-driver-unload.patch
index c2600140..f9148f64 100644
--- a/queue-3.0/r8169-call-netif_napi_del-at-errpaths-and-at-driver-unload.patch
+++ b/queue-3.0/r8169-call-netif_napi_del-at-errpaths-and-at-driver-unload.patch
@@ -14,7 +14,6 @@ delete the NAPI before unregistering netdevice using unregister_netdev.
 
 Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
 Signed-off-by: David S. Miller <davem@davemloft.net>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
  drivers/net/r8169.c |    3 +++
diff --git a/queue-3.0/r8169-config1-is-read-only-on-8168c-and-later.patch b/queue-3.0/r8169-config1-is-read-only-on-8168c-and-later.patch
index dd62d63a..d8690d0d 100644
--- a/queue-3.0/r8169-config1-is-read-only-on-8168c-and-later.patch
+++ b/queue-3.0/r8169-config1-is-read-only-on-8168c-and-later.patch
@@ -12,7 +12,6 @@ Suggested by Hayes.
 
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
 Cc: Hayes Wang <hayeswang@realtek.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-don-t-enable-rx-when-shutdown.patch b/queue-3.0/r8169-don-t-enable-rx-when-shutdown.patch
index ca876bb5..a511d5ec 100644
--- a/queue-3.0/r8169-don-t-enable-rx-when-shutdown.patch
+++ b/queue-3.0/r8169-don-t-enable-rx-when-shutdown.patch
@@ -12,7 +12,6 @@ Only 8111b needs to enable rx when shutdowning with WoL.
 
 Signed-off-by: Hayes Wang <hayeswang@realtek.com>
 Acked-by: Francois Romieu <romieu@fr.zoreil.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-expand-received-packet-length-indication.patch b/queue-3.0/r8169-expand-received-packet-length-indication.patch
index 341ddee4..bbe8a00d 100644
--- a/queue-3.0/r8169-expand-received-packet-length-indication.patch
+++ b/queue-3.0/r8169-expand-received-packet-length-indication.patch
@@ -18,7 +18,6 @@ Realtek's drivers use the same mask for the 816x and the fast ethernet
 only 810x.
 
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-fix-config2-msienable-bit-setting.patch b/queue-3.0/r8169-fix-config2-msienable-bit-setting.patch
index 027e5658..92b29990 100644
--- a/queue-3.0/r8169-fix-config2-msienable-bit-setting.patch
+++ b/queue-3.0/r8169-fix-config2-msienable-bit-setting.patch
@@ -17,7 +17,6 @@ Reported-by: Su Kang Yin <cantona@cantona.net>
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
 Cc: Hayes Wang <hayeswang@realtek.com>
 Signed-off-by: David S. Miller <davem@davemloft.net>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
  drivers/net/r8169.c |   14 ++++++++------
diff --git a/queue-3.0/r8169-fix-unsigned-int-wraparound-with-tso.patch b/queue-3.0/r8169-fix-unsigned-int-wraparound-with-tso.patch
index 665d18a0..82c37928 100644
--- a/queue-3.0/r8169-fix-unsigned-int-wraparound-with-tso.patch
+++ b/queue-3.0/r8169-fix-unsigned-int-wraparound-with-tso.patch
@@ -20,7 +20,6 @@ Zotac 890GXITX.
 Signed-off-by: Julien Ducourthial <jducourt@free.fr>
 Acked-by: Francois Romieu <romieu@fr.zoreil.com>
 Signed-off-by: David S. Miller <davem@davemloft.net>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
  drivers/net/r8169.c |   16 ++++++++++------
diff --git a/queue-3.0/r8169-fix-wake-on-lan-setting-for-non-8111e.patch b/queue-3.0/r8169-fix-wake-on-lan-setting-for-non-8111e.patch
index 4fabe266..fda216e1 100644
--- a/queue-3.0/r8169-fix-wake-on-lan-setting-for-non-8111e.patch
+++ b/queue-3.0/r8169-fix-wake-on-lan-setting-for-non-8111e.patch
@@ -13,7 +13,6 @@ shutdowning for wake on lan.
 
 Signed-off-by: Hayes Wang <hayeswang@realtek.com>
 Acked-by: Francois Romieu <romieu@fr.zoreil.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-increase-the-delay-parameter-of-pm_schedule_suspend.patch b/queue-3.0/r8169-increase-the-delay-parameter-of-pm_schedule_suspend.patch
index b157a375..1cfd3eaa 100644
--- a/queue-3.0/r8169-increase-the-delay-parameter-of-pm_schedule_suspend.patch
+++ b/queue-3.0/r8169-increase-the-delay-parameter-of-pm_schedule_suspend.patch
@@ -17,7 +17,6 @@ would find the driver keep in a loop of runtime_suspend and rumtime_resume.
 Signed-off-by: Hayes Wang <hayeswang@realtek.com>
 Acked-by: Francois Romieu <romieu@fr.zoreil.com>
 Signed-off-by: David S. Miller <davem@davemloft.net>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
  drivers/net/r8169.c |    2 +-
diff --git a/queue-3.0/r8169-jumbo-fixes.patch b/queue-3.0/r8169-jumbo-fixes.patch
index a34f3739..eb33accd 100644
--- a/queue-3.0/r8169-jumbo-fixes.patch
+++ b/queue-3.0/r8169-jumbo-fixes.patch
@@ -19,7 +19,6 @@ commit d58d46b5d85139d18eb939aa7279c160bab70484 upstream.
 - rtl_tx_performance_tweak is moved forward. No change.
 
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-missing-barriers.patch b/queue-3.0/r8169-missing-barriers.patch
index 07f8691b..714f73ab 100644
--- a/queue-3.0/r8169-missing-barriers.patch
+++ b/queue-3.0/r8169-missing-barriers.patch
@@ -9,7 +9,6 @@ commit 1e874e041fc7c222cbd85b20c4406070be1f687a upstream.
 
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
 Cc: Hayes Wang <hayeswang@realtek.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-remove-erroneous-processing-of-always-set-bit.patch b/queue-3.0/r8169-remove-erroneous-processing-of-always-set-bit.patch
index 6f79703a..c0002754 100644
--- a/queue-3.0/r8169-remove-erroneous-processing-of-always-set-bit.patch
+++ b/queue-3.0/r8169-remove-erroneous-processing-of-always-set-bit.patch
@@ -11,7 +11,6 @@ When set, RxFOVF (resp. RxBOVF) is always 1 (resp. 0).
 
 Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
 Cc: Hayes <hayeswang@realtek.com>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Acked-by: David S. Miller <davem@davemloft.net>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
diff --git a/queue-3.0/r8169-runtime-resume-before-shutdown.patch b/queue-3.0/r8169-runtime-resume-before-shutdown.patch
index 5b2757a7..2dec927f 100644
--- a/queue-3.0/r8169-runtime-resume-before-shutdown.patch
+++ b/queue-3.0/r8169-runtime-resume-before-shutdown.patch
@@ -27,7 +27,6 @@ Cc: Hayes Wang <hayeswang@realtek.com>
 Cc: Alan Stern <stern@rowland.harvard.edu>
 Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
 Signed-off-by: David S. Miller <davem@davemloft.net>
-Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
 Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 ---
  drivers/net/r8169.c |    5 +++++
