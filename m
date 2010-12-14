Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab0LNJ51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:57:27 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:54590 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab0LNJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:57:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xjVoX7hSEUFD1X3AS7v7cr1Dt+qS25eju3viFsX6Dz56eC+UTyrLxmVsBBVyjfGiTX
         6RAYEl3o4+6FukGDaaWMTHwtrfK5PMQeFjoTYHB2wfR8XAg4AAjhHfDgtA2K9p+NxbgP
         YdsX239LRdtk8AZaQPgkZTgWH6OdGelwMrJrw=
Message-ID: <4D073FA9.9020801@gmail.com>
Date: Tue, 14 Dec 2010 10:58:01 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe> <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe> <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>
In-Reply-To: <1292288924.2323.458.camel@sli10-conroe>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/14/2010 02:08 AM, Shaohua Li wrote:
> I don't understand what you mean. defining a cachine line size macro
> for all archs? There is such macro, but using it in vmlinux.ld.h
> always report error. There is some other defines which can't be
> included in a link script.

I haven't really looked through it but wouldn't it be possible to
ifdef it.  ie. if cacheline macro is available, align it to it;
otherwise, don't.  And, ultimately, the correct thing to do is making
it cacheline aligned on all archs.  There can be several different
ways to get there but it might just as well be making cacheline size
available in all archs first and then update the PERCPU macro.

Thank you.

-- 
tejun
