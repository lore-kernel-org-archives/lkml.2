Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2ENL2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:28:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64658 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab2ENL2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:28:09 -0400
Message-ID: <4FB0EC2E.9090704@mvista.com>
Date: Mon, 14 May 2012 15:27:42 +0400
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
References: <1337021163-1487-1-git-send-email-changbinx.du@intel.com> <0C18FE92A7765D4EB9EE5D38D86A563A062C91@SHSMSX101.ccr.corp.intel.com> <4FB0D76B.2060603@mvista.com> <0C18FE92A7765D4EB9EE5D38D86A563A062DC8@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A062DC8@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-2012 14:49, Du, ChangbinX wrote:

>> As real device-nodes managed by udev whose nodes lived in /dev/bus/usb
>> are mostly used today, let testusb tool use that directory as one
>> default path make tool be more convenient to use.

>> Signed-off-by: Du Changbin<changbinx.du@intel.com>
>> ---
>>    tools/usb/testusb.c |    6 ++++++
>>    1 file changed, 6 insertions(+)

>> diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index
>> 6e0f567..c6c839e 100644
>> --- a/tools/usb/testusb.c
>> +++ b/tools/usb/testusb.c
> [...]
>> @@ -376,6 +377,11 @@ static const char *usbfs_dir_find(void)
>>    		}
>>    	} while (++it != end);
>>
>> +	/* real device-nodes managed by udev */
>> +	if (access(udev_usb_path, F_OK) == 0) {
>> +		return udev_usb_path;
>> +	}

>      Why {} with single statement?

> Hi, thanks for your tip. It's a code style issue. I will remove {}.

> By the way, I don't know how I can do with this case? Resend a new patch?

    Yes, marking that thsi is a new version of patch in the [PATCH] prefix, 
like [PATCH v2].

> Do I need include discussion message in new patch mail?

    Not necessarily, just indicate the change compared to the old version 
under the --- tear line.

> And how can I know my patch has be accepted? I am a newbie, could you help me?

    You will get a reply from the maintainer, Greg Kroah-Hartman, I think.

> Changbin

WBR, Sergei
