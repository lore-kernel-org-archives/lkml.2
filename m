Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0CYUEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:04:43 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:41365 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0CYUEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=A9gktRAykM3mMEZJrf+9LyzM+RJHQMUstPKjjlp1lQ7fG2s7vqPnqkuXC9w31o0vGC
         9BN52cwrTiPbOULKCeRjO7t/aa5IUGxbAbwIgkM7Z3sBLBya09+dE0nzpkm1vzj9CgIq
         Utf92ysM3CnOODlJptNwbFHnh6Ugf/vcbySlU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, bjorn.helgaas@hp.com, airlied@linux.ie
Subject: [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Date: Thu, 25 Mar 2010 21:04:24 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2; KDE/4.3.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252104.24965.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.33
Failing kernels: 2.6.34-rc1 and 2.6.34-rc2
Driver: Video(DRI - Intel)


When XWindow starts I got:
Mar 25 19:58:10 gumis kernel: [  133.624028] [drm:i915_hangcheck_elapsed] 
*ERROR* Hangcheck timer elapsed... GPU hung
Mar 25 19:58:10 gumis kernel: [  133.624221] render error detected, EIR: 
0x00000000
Mar 25 19:58:10 gumis kernel: [  133.624291] [drm:i915_do_wait_request] 
*ERROR* i915_do_wait_request returns -5 ( awaiting 691 at 682)
Mar 25 19:58:11 gumis kdm[2592]: X server for display :0 terminated 
unexpectedly

after this only SysRq keys work.

Similar problem (older kernels):
https://bugzilla.kernel.org/show_bug.cgi?id=15004

Workaround: setting i915.modeset=1 pci=nocrs OR i915.modeset=0

Dmesg with i915.modeset=1 pci=nocrs:
http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/dmesg2.6.34-rc2.txt

Config:
http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/config-2.6.34-rc2

Syslog (i915.modeset=1 -- when hangs)):
http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/syslog-2.6.34-rc2

lspci:
http://unixy.pl/maciek/download/kernel/2.6.34-rc2/gumis/lspci.txt

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
