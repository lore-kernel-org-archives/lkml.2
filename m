Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2ENKtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:49:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:17520 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab2ENKtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99782887"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] testusb: add path /dev/bus/usb to default search paths
 for usbfs
Thread-Topic: [PATCH] testusb: add path /dev/bus/usb to default search paths
 for usbfs
Thread-Index: AQHNMZ2BooD2tGJJHE+2JranocONc5bI1+TQ//+vK4CAAIfxcA==
Date: Mon, 14 May 2012 10:49:06 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A062DC8@SHSMSX101.ccr.corp.intel.com>
References: <1337021163-1487-1-git-send-email-changbinx.du@intel.com>
 <0C18FE92A7765D4EB9EE5D38D86A563A062C91@SHSMSX101.ccr.corp.intel.com>
 <4FB0D76B.2060603@mvista.com>
In-Reply-To: <4FB0D76B.2060603@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

On 14-05-2012 10:51, Du, ChangbinX wrote:

> As real device-nodes managed by udev whose nodes lived in /dev/bus/usb 
> are mostly used today, let testusb tool use that directory as one 
> default path make tool be more convenient to use.

> Signed-off-by: Du Changbin<changbinx.du@intel.com>
> ---
>   tools/usb/testusb.c |    6 ++++++
>   1 file changed, 6 insertions(+)

> diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index 
> 6e0f567..c6c839e 100644
> --- a/tools/usb/testusb.c
> +++ b/tools/usb/testusb.c
[...]
> @@ -376,6 +377,11 @@ static const char *usbfs_dir_find(void)
>   		}
>   	} while (++it != end);
>
> +	/* real device-nodes managed by udev */
> +	if (access(udev_usb_path, F_OK) == 0) {
> +		return udev_usb_path;
> +	}

    Why {} with single statement?

Hi, thanks for your tip. It's a code style issue. I will remove {}.

By the way, I don't know how I can do with this case? Resend a new patch? Do I need include discussion message in new patch mail?
And how can I know my patch has be accepted? I am a newbie, could you help me?

Changbin

WBR, Sergei
