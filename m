Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2BHUwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:52:05 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1073 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab2BHUwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:52:02 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4F32E062.1020709@broadcom.com>
Date: Wed, 8 Feb 2012 21:51:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111229
 Thunderbird/9.0
MIME-Version: 1.0
To: "Andy Whitcroft" <apw@canonical.com>
cc: "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Joe Perches" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: checkpatch complaint
X-Enigmail-Version: 1.3.4
OpenPGP: id=B5E1A116
X-WSS-ID: 632C3DEE50421347335-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch complains on code below and I must overlook something or
checkpatch gives a false negative/positive/whatever:

#define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
#define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
#define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
#define IFEPDESC(usb, idx, ep)  \
	(IFALTS((usb), (idx)).endpoint[(ep)]).desc

checkpatch errors:
ERROR: Macros with complex values should be enclosed in parenthesis
#169: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:58:
+#define IFDESC(usb, idx)        (IFALTS((usb), (idx))).desc

ERROR: Macros with complex values should be enclosed in parenthesis
#170: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:59:
+#define IFEPDESC(usb, idx, ep)  ((IFALTS((usb),
(idx))).endpoint[(ep)]).desc

Any ideas? I tried extra parenthesis around IFALTS but that does not
resolve it.

Gr. AvS

