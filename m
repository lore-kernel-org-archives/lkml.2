Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1ERWqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:46:19 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4659 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab1ERWqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:46:18 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4DD44C21.1080502@broadcom.com>
Date: Wed, 18 May 2011 15:45:53 -0700
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
        "Henry Ptasinski" <henryp@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: brcmfmac: Add and use dhd_dbg
References: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
In-Reply-To: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
X-WSS-ID: 61CA929B1IC9114314-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 11:23 AM, Joe Perches wrote:
> All uses of DHD_<TYPE>  macros are for debugging only.
>
> Change the multiple uses of DHD_<TYPE>((...)) to dhd_dbg(TYPE, ...)
> for a more consistent style.

I generally like this approach, but in brcmsmac we've been switching to 
wiphy_err() and related instead.  Any strong argument for one over the 
other?

> -       DHD_TRACE(("%s: Enter\n", __func__));
> +       dhd_dbg(TRACE, "%s: Enter\n", __func__);


I'd propose moving __func__ into the macro definition itself, which 
would help ensure consistency (and shorten all the debug lines a bit).

Also, perhaps rename to "brcm_dbg()", "bcm_dbg()" or something like that 
and move it into include/bcmutils.h, so brcmsmac can use it as well.

- Henry

