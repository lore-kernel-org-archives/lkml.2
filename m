Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1DZAsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:48:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42668 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab1DZAsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=mIvB1i9ah8LtoDjoXjiRs+aD1TyQ56v/EhdGNz3GalOiGfSHarcRVTYjrKAbtu7/ga
         murk2cjvfMjmd9n5+cebNdkrSc9hFL1eVl482qdX+k1RRl0TBHpAeosw3RV56//VzGhg
         0bVcsA7m0dvvOoIPl6xsEit0qofcHp3HaHN7I=
Message-ID: <4DB61645.8010001@lwfinger.net>
Date: Mon, 25 Apr 2011 19:48:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Subject: Re: r8712u cannot set essid
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>	<4DB4E94C.2060505@lwfinger.net>	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>	<4DB5C8FA.2030700@lwfinger.net> <BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>
In-Reply-To: <BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060206080507010707080002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060206080507010707080002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/25/2011 07:21 PM, Jeff Chua wrote:
> On Tue, Apr 26, 2011 at 3:18 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> Please send me the commands that you want to use, and I'll try to get r8712u
>> to support them.
>
> Larry,
>
> All I want is for my iPhone to connect to me notebook, and I use this
> command ...
>
> # iwconfig wlan0 mode ad-hoc essid "123"
>
> A little bit of good news is that I got adhoc to work 2 out of 100
> tries (with wpa_supplicant on another sreen, and the above iwconfig
> command). So, it's working "partially". Once it has an SSID, I could
> change it and it'll still work.

Please try the attached patch.

Larry

--------------060206080507010707080002
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

--------------060206080507010707080002--
