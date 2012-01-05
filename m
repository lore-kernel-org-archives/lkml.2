Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab2AEXnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:43:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151Ab2AEXm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:42:59 -0500
Message-ID: <4F06357E.8050000@lwfinger.net>
Date: Thu, 05 Jan 2012 17:42:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        gwingerde@gmail.com, davem@davemloft.net, bhutchings@solarflare.com,
        greg@kroah.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
References: <1325796541-11402-1-git-send-email-festevam@gmail.com> <4F0635FE.6050507@xenotime.net>
In-Reply-To: <4F0635FE.6050507@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 05:45 PM, Randy Dunlap wrote:
> On 01/05/2012 12:49 PM, Fabio Estevam wrote:
>> MISC_DEVICES option alone does not select any kernel code and can cause dependency build warnings, such as:
>>
>> warning: (KS8851&&  AX88796_93CX6&&  RTL8180&&  RTL8187&&  ADM8211&&  RT2400PCI&&  RT2500PCI&&  RT61PCI&&  RT2800PCI&&  R8187SE) selects EEPROM_93CX6 which has unmet direct dependencies (MISC_DEVICES)
>>
>> Remove MISC_DEVICES option so that any dependency on this symbol is avoided.
>
> I thought that one purpose of MISC_DEVICES was to allow anyone to disable all
> options under it with one click (or keystroke), but since several drivers now
> "select MISC_DEVICES", that does not work.
>
> I would like to be able to disable all MISC_DEVICES, but since that
> does not currently function, this change is OK with me.

All of the drivers in the above list select *only* one driver in the 
MISC_DEVICES category. If that one were moved outside of MISC_DEVICES, most, if 
not all,problems would go away.

Larry
