Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1DYTS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:18:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43031 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab1DYTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wx8sY1jRn2CRTo2GkTUJ8PZ9Dmt+SL/06faBl8GpXeZ4h2jmxdEkZ3QZJe2H63moAd
         tSzZ49Einu2WjRIQZphRGImAIE6QRbGXa8TlcDnpARNLsw/3v/2F2fqWN4Ns0jxeqFKE
         K/V5qHD4QHhC60GptrUgDsGEauglVrVkt0cOo=
Message-ID: <4DB5C8FA.2030700@lwfinger.net>
Date: Mon, 25 Apr 2011 14:18:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Subject: Re: r8712u cannot set essid
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>	<4DB4E94C.2060505@lwfinger.net> <BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
In-Reply-To: <BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2011 11:32 PM, Jeff Chua wrote:
> On Mon, Apr 25, 2011 at 11:23 AM, Larry Finger
> <Larry.Finger@lwfinger.net>  wrote:
>> On 04/24/2011 09:16 PM, Jeff Chua wrote:
>> The code requires the interface to be up before the essid can be set. If you
>> do it with the iwconfig command, you will see an error message.
>
> I did that. Setting ssid works fine with iwlagn on the same system.

That is a different driver.

> # modprobe r8712u
> r8712u: module is from the staging directory, the quality is unknown,
> you have been warned.
> r8712u: DriverVersion: v7_0.20100831
> r8712u: register rtl8712_netdev_ops to netdev_ops
> r8712u: USB_SPEED_HIGH with 4 endpoints
> r8712u: Boot from EFUSE: Autoload OK
> r8712u: CustomerID = 0x0000
> r8712u: MAC Address from efuse = 90:61:0c:01:8f:b0
> usbcore: registered new interface driver r8712u
>
>
> # ifconfig wlan0 up
> r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> r8712u: 1 RCR=0x153f00e
> r8712u: 2 RCR=0x553f00e
>
> # iwconfig wlan0 essid "123"
> # iwconfig wlan0
> wlan0     unassociated  Nickname:"rtl_wifi"
>            Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0
>            Retry:off   RTS thr:off   Fragment thr:off
>            Encryption key:off
>            Power Management:off
>            Link Quality:0  Signal level:0  Noise level:0
>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>            Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
>
>
>
>> I'm not sure if this is a reasonable requirement before allowing the essid
>> to be set. Any thoughts?
>
> As long as it works, I don't mind. But it's not working. I've tried
> all sorts of combination of "ifconfig up/down" + "iwconfig essid" but
> still not working.
>
>
> Here's more info if it helps.
>
> # cat /proc/bus/usb/devices
> T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=07b8 ProdID=8188 Rev= 2.00
> S:  Manufacturer=Manufacturer Realtek
> S:  Product=RTL8188S WLAN Adapter
> S:  SerialNumber=00e04c000001
> C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=ff Prot=ff Driver=r8712u
> E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=0d(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>
> # grep /usr/src/linux/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> {RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
>
> I also tried this ...
>
> # modprobe rtl8192cu
> # ifconfig wlan1 up     # hangs here!
>
> usbcore: registered new interface driver rtl8192cu
> rtl8192cu:_rtl92cu_init_power_on():<0-0>  Failed to polling
> REG_APS_FSMCO[APFM_ONMAC] done!
> rtl8192cu:_rtl92cu_init_mac():<0-0>  Failed to init power on!
> rtl8192cu:rtl92cu_hw_init():<0-0>  init mac failed!

There is a problem here. Driver r8712u is for the RTL8192SU/RTL8188SU devices 
and rtl8192cu is for the RTL8192CU/RTL8188CU. The chips are very different. 
Having the same USB ID in both is clearly wrong. Unfortunately, that ID is not 
listed at http://www.linux-usb.org/usb.ids. I'll check with Realtek to be sure, 
but I think it needs to be deleted from rtl8192cu.

Please send me the commands that you want to use, and I'll try to get r8712u to 
support them. AP mode may not be possible.

Larry
