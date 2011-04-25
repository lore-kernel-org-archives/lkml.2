Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1DYDYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 23:24:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57660 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab1DYDYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 23:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jayw0J8KFb06OCCv+/FF/tdOH+ZUmplXlm2/6xwKq1FwUBF5rEWvnKk3A5EqHf7bVV
         4GVD9cvH5CftV42XniYg1qwX8U4Pot2KxQW7JD7f5uCI9smVwiaolgBeLDEgf3mVMt9y
         F+DrNAaZAEB0etf6O+0UoYLzz9vFH7YOb5Cw8=
Message-ID: <4DB4E94C.2060505@lwfinger.net>
Date: Sun, 24 Apr 2011 22:23:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Subject: Re: r8712u cannot set essid
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
In-Reply-To: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2011 09:16 PM, Jeff Chua wrote:
> I'm having problem trying to set essid on the "Realtek RTL8188S WLAN
> Adapter" with the r8172u module on 2.6.39-rc4. There's no error. Just
> can't set.
>
>
> # dmesg ...
> r8712u: module is from the staging directory, the quality is unknown,
> you have been warned.
> r8712u: DriverVersion: v7_0.20100831
> r8712u: register rtl8712_netdev_ops to netdev_ops
> r8712u: USB_SPEED_HIGH with 4 endpoints
> r8712u: Boot from EFUSE: Autoload OK
> r8712u: CustomerID = 0x0000
> r8712u: MAC Address from efuse = 90:61:0c:01:8f:b0
> usbcore: registered new interface driver r8712u
> r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> r8712u: 1 RCR=0x153f00e
> r8712u: 2 RCR=0x553f00e
>
> # iwconfig wlan1 essid "tryanything"
> # iwconfig wlan1
> wlan1     IEEE 802.11b  ESSID:""  Nickname:"rtl_wifi"
>            Mode:Ad-Hoc  Cell: Not-Associated   Bit Rate:0 kb/s
>            Sensitivity:0/0
>            Retry:off   RTS thr:off   Fragment thr:off
>            Encryption key:off
>            Power Management:off
>            Link Quality:0  Signal level:0  Noise level:0
>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>            Tx excessive retries:0  Invalid misc:0   Missed beacon:0

The code requires the interface to be up before the essid can be set. If you do 
it with the iwconfig command, you will see an error message.

I'm not sure if this is a reasonable requirement before allowing the essid to be 
set. Any thoughts?

Larry
