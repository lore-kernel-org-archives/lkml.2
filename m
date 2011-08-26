Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1HZJY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:24:28 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3714 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1HZJY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:24:26 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4E576637.4020209@broadcom.com>
Date: Fri, 26 Aug 2011 11:24:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18)
 Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Joe Perches" <joe@perches.com>, "Henry Ptasinski" <henryp@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Greg KH" <gregkh@suse.de>, "Kan Yan" <kanyan@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
 <CACna6ryWtZG9obyj0w=d5jrF-y1pYNmanhkze2F429kHCLCi=A@mail.gmail.com>
 <1314349357.9624.3.camel@Joe-Laptop>
 <CACna6rwvaxd4i0Gh0hFRsXhHKBBLgn+SeMEdM62qf=mT7aCzpA@mail.gmail.com>
In-Reply-To: <CACna6rwvaxd4i0Gh0hFRsXhHKBBLgn+SeMEdM62qf=mT7aCzpA@mail.gmail.com>
X-WSS-ID: 6249B8083KO10170203-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 11:19 AM, Rafał Miłecki wrote:
> W dniu 26 sierpnia 2011 11:02 użytkownik Joe Perches<joe@perches.com>  napisał:
>> On Fri, 2011-08-26 at 10:55 +0200, Rafał Miłecki wrote:
>>> 2011/8/25 Joe Perches<joe@perches.com>:
>>>> Convert multiple BRCMF_<debug_level>  macros to a single
>>>> brcmf_dbg(level, fmt, ...) macro.
>>> I'm not sure if that "_dbg" suffix is a really good choice. You use
>>> "_dbg" for all the kinds of messages, while "DEBUG" is already one
>>> kind of messages.
>> No, not really.  These _are_ debugging uses.
>>
>> The #include is called dhd_dbg.h and
>> the whole block is guarded by
>>
>> #if defined(BCMDBG)
>>
>>> We have also other types like EMERG, ALERT, CRIT,
>>> ERR, WARNING, NOTICE, INFO and DEBUG.
>> Except for the last, those aren't debugging uses,
>> these are.
> It makes sense, maybe some messages should be just always printed. It
> seems some of they may be important for common-user having problem
> with his card. Just few random ones:
> brcmf_dbg(ERROR, "device attach failed\n");
> brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
> brcmf_dbg(ERROR, "MACEVENT: %s [unsupported version -->  brcmf
> version:%d dongle version:%d]\n",
> brcmf_dbg(ERROR, "mismatched OUI, bailing\n");
> brcmf_dbg(ERROR, "brcmf_net_attach failed, err %d\n",
> brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
> brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);

Hi Rafał,

The feedback from Greg was that no user would be interested in it so we 
cleaned it up and put it under Kconfig option.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


