Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1FRPwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:52:30 -0400
Received: from mta11.charter.net ([216.33.127.80]:44568 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1FRPw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:52:29 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=p9YancsnzTcA:10 a=ATN9wnctRWoA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=Q-fNiiVtAAAA:8 a=FcborOI1YaU8jPD6dEEA:9
 a=cmryx0jSbUdzuLlkYTsA:7 a=wPNLvfGTeEIA:10 a=lcTMV_K9oDIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DFCC9BE.6000006@cuw.edu>
Date: Sat, 18 Jun 2011 10:52:30 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: Julian Calaby <julian.calaby@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        Brett Rudley <brudley@broadcom.com>, Dowan Kim <dowan@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: return false if not a broadcom board
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu> <20110616013615.GA14700@broadcom.com> <4DF96F22.5070508@cuw.edu> <20110616233736.GA2344@broadcom.com> <BANLkTi=tLWXn7mMf-6pf-3gM6x8zX=WNtw@mail.gmail.com> <20110617220108.GH3801@broadcom.com>
In-Reply-To: <20110617220108.GH3801@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2011 05:01 PM, Henry Ptasinski wrote:
> On Thu, Jun 16, 2011 at 04:45:21PM -0700, Julian Calaby wrote:
>    
>> Henry,
>>
>> On Fri, Jun 17, 2011 at 09:37, Henry Ptasinski<henryp@broadcom.com>  wrote:
>>      
>>> How's this for a somewhat clearer implementation:
>>>
>>> static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
>>> {
>>>         bool goodboard = true;
>>>         uint boardrev = wlc_hw->boardrev;
>>>
>>>         if (wlc_hw->sih->boardvendor == PCI_VENDOR_ID_BROADCOM) {
>>>        
>> You could reduce indentation by having this be:
>>
>> if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
>>      return true;
>>
>>      
>>>                 /* validate boardrev */
>>>                 if (boardrev == 0)
>>>                         goodboard = false;
>>>        
>> and remove the goodboard variable by having this return false immediately.
>>
>>      
>>>                 else if (boardrev>  0xff) {
>>>        
>> You could also drop the else and have this as
>>
>> if (boardrev<= 0xff)
>>      return true;
>>
>>      
>>>                         /* 4 bits each for board type, major, minor, and tiny
>>>                         version numbers */
>>>                         uint brt = (boardrev&  0xf000)>>  12;
>>>                         uint b0 = (boardrev&  0xf00)>>  8;
>>>                         uint b1 = (boardrev&  0xf0)>>  4;
>>>                         uint b2 = boardrev&  0xf;
>>>
>>>                         if ((brt>  2) || (brt == 0) || (b0>  9) || (b0 == 0)
>>>                                 || (b1>  9) || (b2>  9))
>>>                                 goodboard = false;
>>>        
>> and return false here too.
>>
>>      
>>>                 }
>>>         }
>>>
>>>         return goodboard;
>>>        
>> then just return true here.
>>
>>      
>>> }
>>>        
>> Thanks,
>>
>> -- 
>> Julian Calaby
>>      
> Yea, it's a lot flatter with those changes.  Look for it in a patch set
> relatively soon ...
>
> - Henry
>
>
>    

All good points above - also, I might add a short comment to explain why 
the code checks the vendor id so it's clear to people who read the code 
in the future too.

Greg

