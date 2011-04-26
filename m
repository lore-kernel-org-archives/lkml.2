Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1DZPc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:32:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35599 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1DZPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=LygWQd8pak8lQeChFLVEyc+b8s+lKvRhGJEa74/pqdoa35cg2sehTcHISk2XLVcLd1
         sDSFB0Jn0sqxYnGx+SygJ4JOvn18D7AqrnsrdtzihfnXWIXi8b25JfypDQ5mEs7RxJfu
         dtPW8P+iphGnSbsCU1Qs5CyO6m4tcvJ0Xftbo=
Message-ID: <4DB6E584.9040504@lwfinger.net>
Date: Tue, 26 Apr 2011 10:32:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Subject: Re: r8712u cannot set essid
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>	<4DB4E94C.2060505@lwfinger.net>	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>	<4DB5C8FA.2030700@lwfinger.net>	<BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>	<4DB61645.8010001@lwfinger.net> <BANLkTikWHxEnzZ+H1OgFv7AdmpmmcwVuzA@mail.gmail.com>
In-Reply-To: <BANLkTikWHxEnzZ+H1OgFv7AdmpmmcwVuzA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030401060004080802090307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030401060004080802090307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/25/2011 10:26 PM, Jeff Chua wrote:
> On Tue, Apr 26, 2011 at 8:48 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 04/25/2011 07:21 PM, Jeff Chua wrote:
>>> A little bit of good news is that I got adhoc to work 2 out of 100
>>> tries (with wpa_supplicant on another sreen, and the above iwconfig
>>> command). So, it's working "partially". Once it has an SSID, I could
>>> change it and it'll still work.
>>
>> Please try the attached patch.
>
> Tried, but didn't make any difference.
>
> Now I can make adhoc work 100% if I first put the device in wpa2
> infrastructure and associates it with an AP. Then kill the
> wpa_supplicant process, and start a new wpa_supplicant with adhoc
> config.
>
> If I just start with the wpa_supplicant adhoc config, it'll never set the ssid.
>
> So, something is not right in the r8712u module or may be the firmware?

I must have something wrong in my setup, thus my testing did not work. There is 
another place in the code where the setting of parameters requires the interface 
to be connected. Please try the attached patch.

Larry

--------------030401060004080802090307
Content-Type: text/plain;
 name="r8712u_set_essid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="r8712u_set_essid"

Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
 	struct wlan_network *pnetwork = NULL;
 	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
 
-	if (padapter->bup == false)
-		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
@@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
 	struct list_head *phead;
 	u32 len;
 
-	if (padapter->bup == false)
-		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

--------------030401060004080802090307--
