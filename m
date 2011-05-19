Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1ESAqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:46:55 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3662 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1ESAqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:46:53 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4DD46865.9010708@broadcom.com>
Date: Wed, 18 May 2011 17:46:29 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Dowan Kim" <dowan@broadcom.com>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Arend Van Spriel" <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: brcmfmac: Add and use dhd_dbg
References: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
 <4DD44C21.1080502@broadcom.com> <1305765163.1745.4.camel@Joe-Laptop>
In-Reply-To: <1305765163.1745.4.camel@Joe-Laptop>
X-WSS-ID: 61CAB6C23IC2928684-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 05:32 PM, Joe Perches wrote:
> On Wed, 2011-05-18 at 15:45 -0700, Henry Ptasinski wrote:
>> On 05/18/2011 11:23 AM, Joe Perches wrote:
>>> All uses of DHD_<TYPE>   macros are for debugging only.
>>> Change the multiple uses of DHD_<TYPE>((...)) to dhd_dbg(TYPE, ...)
>>> for a more consistent style.
>> I generally like this approach, but in brcmsmac we've been switching to
>> wiphy_err() and related instead.  Any strong argument for one over the
>> other?
>
> These aren't described as errors but are debugging messages.

Yes, so wiphy_debug(), wiphy_info(), wiphy_notice(), etc could be used. 
  It's not as fine grained as the current logging mechanism, so that 
would be one argument against using wiphy_*.  I don't have a strong 
opinion either way, just looking to see which is the generally preferred 
approach in the kernel (if there is any preference).


>>> -       DHD_TRACE(("%s: Enter\n", __func__));
>>> +       dhd_dbg(TRACE, "%s: Enter\n", __func__);
>> I'd propose moving __func__ into the macro definition itself, which
>> would help ensure consistency (and shorten all the debug lines a bit).
>
> I think TRACE is unnecessary and can be eliminated
> and replaced by the function tracer.
>
> Not all uses use __func__.

That's just sloppiness on our part.  They should all be consistent.

> I think __func__ unnecessary and it should be avoided.

If it's moved into the macro, then there's only one place to change if 
you want to delete "__func__"/add it back/include it conditionally.


> Other than that, I've no objections.
>
>> Also, perhaps rename to "brcm_dbg()", "bcm_dbg()" or something like that
>> and move it into include/bcmutils.h, so brcmsmac can use it as well.
>
> Your choice.

"brcm_dbg()" seems fine to me.

- Henry

