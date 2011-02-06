Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1BFXdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:33:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44088 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab1BFXdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:33:22 -0500
Message-ID: <4D4F2F92.9080902@zytor.com>
Date: Sun, 06 Feb 2011 15:32:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: 7eggert@nurfuerspam.de
CC: Bodo Eggert 
	<arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de>,
        Ingo Molnar <mingo@elte.hu>, castet.matthieu@free.fr,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <ghb2G-3tw-7@gated-at.bofh.it> <ghjtg-WV-5@gated-at.bofh.it> <ghosV-TN-9@gated-at.bofh.it> <ghEo1-2IF-1@gated-at.bofh.it> <gifGW-7eL-13@gated-at.bofh.it> <E1Pm1so-00025V-Am@be1.7eggert.dyndns.org>
In-Reply-To: <E1Pm1so-00025V-Am@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 02:30 AM, Bodo Eggert wrote:
> H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> In static_protections() we have:
>>
>>>         /*
>>>          * The BIOS area between 640k and 1Mb needs to be executable for
>>>          * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
>>>          */
> 
> I don't think the CGA/MDA/VGA graphics memory areas should be executable,
> and I doubt execute access to these areas is required - is it?
> 
> 0xA000:0000 might be a BIOS area, if it is, you don't have a VGA and the
> ROM will be exactly 64K. 0xB800 and 0xB000 SHOULD NOT be a ROM, nobody dared
> to use it (I don't remember exactly where ROMs are searched).


0xA0000..0xBFFFF can be ROM if you don't have a VGA card; this is new in
PCI 3.x IIRC.  However, in legacy systems you will not have ROM in this
area.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

