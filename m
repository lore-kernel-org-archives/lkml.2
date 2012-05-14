Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2ENJ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:59:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35624 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2ENJ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:59:35 -0400
Message-ID: <4FB0D76B.2060603@mvista.com>
Date: Mon, 14 May 2012 13:59:07 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Du, ChangbinX" <changbinx.du@intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] testusb: add path /dev/bus/usb to default search paths
 for usbfs
References: <1337021163-1487-1-git-send-email-changbinx.du@intel.com> <0C18FE92A7765D4EB9EE5D38D86A563A062C91@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A062C91@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-05-2012 10:51, Du, ChangbinX wrote:

> As real device-nodes managed by udev whose nodes lived in /dev/bus/usb
> are mostly used today, let testusb tool use that directory as one default
> path make tool be more convenient to use.

> Signed-off-by: Du Changbin<changbinx.du@intel.com>
> ---
>   tools/usb/testusb.c |    6 ++++++
>   1 file changed, 6 insertions(+)

> diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
> index 6e0f567..c6c839e 100644
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

WBR, Sergei
