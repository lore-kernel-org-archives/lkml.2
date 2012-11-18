Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2KRUSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:18:43 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:57344 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KRUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:18:41 -0500
Message-ID: <50A9429D.1010908@lwfinger.net>
Date: Sun, 18 Nov 2012 14:18:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Josh Coombs <josh.coombs@gmail.com>,
        linux ARM <linux-arm-kernel@lists.infradead.org>, wlanfae@realtek.com,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v1 1/1] RTL8712 alignment bug in 3.6.5 on ARM
References: <CAMW5UfYUi-Zz2r5K9GeVzShSub2rDJVuoWR56+89+ytaqo_uxQ@mail.gmail.com> <20121118181140.GC14643@lunn.ch>
In-Reply-To: <20121118181140.GC14643@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 12:11 PM, Andrew Lunn wrote:
>
> Just to clarify the issue here:
>
> union pn48 {
>          u64 val;
> #if defined(__BIG_ENDIAN)
>          struct {
>                  u8 TSC7;
>                  u8 TSC6;
>
> Any instance of pn48 needs to be 64 bit aligned when the val member of
> the union is used. The structure sta_info contains two such pn48s, so
> the code allocating the pool of these needs to ensure it allocated
> them 64 bit aligned, not 32bit aligned as it currently is.

Andrew,

For my education, would the following patch ensure 64-bit alignment for the pn48 
instances, or is more needed?

Index: staging/drivers/staging/rtl8712/rtl871x_security.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_security.h
+++ staging/drivers/staging/rtl8712/rtl871x_security.h
@@ -89,6 +89,8 @@ struct RT_PMKID_LIST {
  };

  struct security_priv {
+       union pn48 Grptxpn;             /* PN48 used for Grp Key xmit. */
+       union pn48 Grprxpn;             /* PN48 used for Grp Key recv. */
         u32 AuthAlgrthm;                /* 802.11 auth, could be open, shared,
                                          * 8021x and authswitch */
         u32 PrivacyAlgrthm;             /* This specify the privacy for shared
@@ -104,8 +106,6 @@ struct security_priv {
                                          * inx0 and inx1 */
         union Keytype   XGrptxmickey[2];
         union Keytype   XGrprxmickey[2];
-       union pn48 Grptxpn;             /* PN48 used for Grp Key xmit. */
-       union pn48 Grprxpn;             /* PN48 used for Grp Key recv. */
         u8 wps_hw_pbc_pressed;/*for hw pbc pressed*/
         u8 wps_phase;/*for wps*/
         u8 wps_ie[MAX_WPA_IE_LEN<<2];

Thanks,

Larry


