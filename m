Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab1D2Agu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:36:50 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48555 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1D2Agt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f6O7A5g0rdMSsn6SW1sAGicJUfYnvPFnhEDYsY1n+uWjvSWoYoFt2LJeCH5V1tEs3L
         Pzsg85dcW4cNOCNX/alyxVm5H/N8LryOpJpCXSLfJuTZCtmehqDlZpPq7j5eJiCFWcM2
         StPRpZlxz58s1rq5QnuwoWMRpEWbxUEcBIoQI=
MIME-Version: 1.0
In-Reply-To: <20110428201527.GA3738@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
	<20110428150819.GA3713@spotteswoode.de.eu.org>
	<4DB9884F.10409@lwfinger.net>
	<BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
	<20110428201527.GA3738@spotteswoode.de.eu.org>
Date: Fri, 29 Apr 2011 08:36:48 +0800
Message-ID: <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 4:15 AM, clemens fischer
<ino-news@spotteswoode.dnsalias.org> wrote:
>> Jeff Chua:
>
>> iwconfig doesn't work by itself to set adhoc mode (I haven't figure
>> why either). You can get into "adhoc mode", but you won't see
>> ESSID:XXXX.
>>
>> Can you please try "wpa_supplicant" instead?
>
> Well, I never figured out how to configure adhoc-mode using
> "wpa_supplicant", could you please send a minimal working config entry?

Clemens,

Try this. This is my working config.


# /etc/wpa1.conf
ap_scan=2       # 0 does not work. 1 is ok. 2 is fast.

network={
        auth_alg=SHARED
        mode=1          # ad-hoc
        group=WEP104
        ssid="yourSSID"
        wep_key0=1234567890ABCDEF123456678
        wep_tx_keyidx=0
        key_mgmt=NONE
        priority=0
        scan_ssid=0
        frequency=2412
}


# modprobe r8712u
# iwconfig     <- you should be able to see 'wlan0' or 'wlan1' if
you've more than 1 wireless
# ifconfig wlan0 up
# wpa_supplicant -i wlan0 -c /etc/wpa1.conf


That should work.

Jeff
