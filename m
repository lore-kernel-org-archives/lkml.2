Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab1H0H30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 03:29:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59573 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1H0H3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 03:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <4E576637.4020209@broadcom.com>
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
	<CACna6ryWtZG9obyj0w=d5jrF-y1pYNmanhkze2F429kHCLCi=A@mail.gmail.com>
	<1314349357.9624.3.camel@Joe-Laptop>
	<CACna6rwvaxd4i0Gh0hFRsXhHKBBLgn+SeMEdM62qf=mT7aCzpA@mail.gmail.com>
	<4E576637.4020209@broadcom.com>
Date: Sat, 27 Aug 2011 09:29:23 +0200
Message-ID: <CACna6rxc=Kpy+_S2BE7tui_oy-C7vCUQDHDa5XQ+jLp0p=vG8Q@mail.gmail.com>
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Joe Perches <joe@perches.com>, Henry Ptasinski <henryp@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Greg KH <gregkh@suse.de>, Kan Yan <kanyan@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26 sierpnia 2011 11:24 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 08/26/2011 11:19 AM, Rafał Miłecki wrote:
>>
>> W dniu 26 sierpnia 2011 11:02 użytkownik Joe Perches<joe@perches.com>
>>  napisał:
>>>
>>> On Fri, 2011-08-26 at 10:55 +0200, Rafał Miłecki wrote:
>>>>
>>>> 2011/8/25 Joe Perches<joe@perches.com>:
>>>>>
>>>>> Convert multiple BRCMF_<debug_level>  macros to a single
>>>>> brcmf_dbg(level, fmt, ...) macro.
>>>>
>>>> I'm not sure if that "_dbg" suffix is a really good choice. You use
>>>> "_dbg" for all the kinds of messages, while "DEBUG" is already one
>>>> kind of messages.
>>>
>>> No, not really.  These _are_ debugging uses.
>>>
>>> The #include is called dhd_dbg.h and
>>> the whole block is guarded by
>>>
>>> #if defined(BCMDBG)
>>>
>>>> We have also other types like EMERG, ALERT, CRIT,
>>>> ERR, WARNING, NOTICE, INFO and DEBUG.
>>>
>>> Except for the last, those aren't debugging uses,
>>> these are.
>>
>> It makes sense, maybe some messages should be just always printed. It
>> seems some of they may be important for common-user having problem
>> with his card. Just few random ones:
>> brcmf_dbg(ERROR, "device attach failed\n");
>> brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
>> brcmf_dbg(ERROR, "MACEVENT: %s [unsupported version -->  brcmf
>> version:%d dongle version:%d]\n",
>> brcmf_dbg(ERROR, "mismatched OUI, bailing\n");
>> brcmf_dbg(ERROR, "brcmf_net_attach failed, err %d\n",
>> brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
>> brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);
>
> Hi Rafał,
>
> The feedback from Greg was that no user would be interested in it so we
> cleaned it up and put it under Kconfig option.

Having messages like "Entered xxx function" are really useless for
common user, but I believe errors should be printed, to let use known
sth is wrong.

Did Greg really mean all that messages? Including error ones? Greg?

-- 
Rafał
