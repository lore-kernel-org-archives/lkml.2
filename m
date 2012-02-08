Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2BHXmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:42:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45211 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756001Ab2BHXmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:42:17 -0500
Message-ID: <1328744534.6909.2.camel@joe2Laptop>
Subject: Re: checkpatch complaint
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 08 Feb 2012 15:42:14 -0800
In-Reply-To: <4F32E062.1020709@broadcom.com>
References: <4F32E062.1020709@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 21:51 +0100, Arend van Spriel wrote:
> checkpatch complains on code below and I must overlook something or
> checkpatch gives a false negative/positive/whatever:
> 
> #define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
> #define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
> #define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
> #define IFEPDESC(usb, idx, ep)  \
> 	(IFALTS((usb), (idx)).endpoint[(ep)]).desc
> 
> checkpatch errors:
> ERROR: Macros with complex values should be enclosed in parenthesis
> #169: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:58:
> +#define IFDESC(usb, idx)        (IFALTS((usb), (idx))).desc
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #170: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:59:
> +#define IFEPDESC(usb, idx, ep)  ((IFALTS((usb),
> (idx))).endpoint[(ep)]).desc
> 
> Any ideas? I tried extra parenthesis around IFALTS but that does not
> resolve it.

I think the entries should be surround by ()
I think it's reasonable too.

I tried:

$ cat cp.c
#define IFPTR(usb, idx)		((usb)->actconfig->interface[(idx)])
#define IFALTS(usb, idx)	(IFPTR((usb), (idx))->altsetting[0])
#define IFDESC(usb, idx)	(IFALTS((usb), (idx)).desc)
#define IFEPDESC(usb, idx, ep)	((IFALTS((usb), (idx)).endpoint[(ep)]).desc)

$ ./scripts/checkpatch.pl -f cp.c
total: 0 errors, 0 warnings, 5 lines checked

cp.c has no obvious style problems and is ready for submission.



