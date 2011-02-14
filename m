Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1BNQRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:17:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63887 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1BNQRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:17:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cas860dlnx/N64cVxwPdmql0klDXk0DqYsMQ7vofuQU1cDV07vaoKkf7MefZFzROA6
         pu3NWfyxWDAUwOtYTDKh2CZab8SSpU1n91zQo5vcbv8FTamHNWIETR8HJju24QUsZl6o
         ZP11FdxPasrd/lPVq89DNJCZEZPh75e+W1NoI=
MIME-Version: 1.0
In-Reply-To: <20110214161249.GV18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-16-git-send-email-tj@kernel.org>
	<4D5729A7.7070706@kernel.org>
	<20110214113221.GG18742@htj.dyndns.org>
	<AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
	<20110214161249.GV18742@htj.dyndns.org>
Date: Mon, 14 Feb 2011 08:17:46 -0800
X-Google-Sender-Auth: 7BpGwOGelEMcTIy1YldRNsUUJOw
Message-ID: <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 8:12 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Feb 14, 2011 at 08:08:08AM -0800, Yinghai Lu wrote:
>> > No, I don't think so.  If you don't like the function name, let's
>> > change the name.  I think it's better to put all registrations there.
>> > Later in the series but function is changed to deal with struct
>> > numa_meminfo anyway so maybe it's better to rename it to
>> > numa_register_meminfo().
>>
>> No, I don't like ***_register_*** take care of calling setup_bootmem.
>
> Yeah, then, please go ahead and suggest the name you want.  I don't
> really care about the name itself, but I don't want to put it directly
> in initmem_init() because with double calling and extra loop added
> later it gets nested too deep.  For now, let's move on, okay?  We can
> argue about this for days but there's no clear technical
> [dis]advantage one way or the other and falls squarely in the scope of
> bikeshedding.
>
why not do it at first point ?

numa_register_meminfo() should only take care of creating correctly
struct numa_meminfo.

Yinghai
