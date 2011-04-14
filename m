Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab1DNOch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:32:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837Ab1DNOcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:32:36 -0400
Message-ID: <4DA7054B.1060203@zytor.com>
Date: Thu, 14 Apr 2011 07:31:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joro@8bytes.org>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <4DA654D6.2060103@zytor.com> <20110414085624.GC18463@8bytes.org> <20110414091137.GC9248@elte.hu>
In-Reply-To: <20110414091137.GC9248@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 02:11 AM, Ingo Molnar wrote:
> 
> I'd strongly suggest we revert back to the old and proven allocation order, as 
> long as it results in valid layouts. Even if we figure out this particular 
> GART/GTT assumption there might be a dozen others in other types of hardware.
> 

Yes, but we might also be hiding a real bug which bites other hardware.
 We have found real and very serious bugs in the kernel this way before
-- things where drivers scribble over random memory and allocation order
exposed the failure in a predictable way, as opposed to random crashes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

