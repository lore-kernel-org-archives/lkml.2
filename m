Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2GAPeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:34:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42236 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab2GAPeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:34:16 -0400
Message-ID: <4FF06DF4.4000006@zytor.com>
Date: Sun, 01 Jul 2012 08:34:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com> <4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com> <4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com> <877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
In-Reply-To: <4FF06701.6010004@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 08:04 AM, H. Peter Anvin wrote:
>
> Sadly, this patch breaks the boot with of of my standard configurations
> (attached)... it goes into an infinite reboot loop.  This was the first
> config I tested, so it might very well break more.
>

Some more investigation: the boot crashes because the .data..percpu 
segment is all zero -- since this includes the GDT, we die quickly and 
dramatically only a handful of instructions into head_64.S.

I'm dropping this patchset for now.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



