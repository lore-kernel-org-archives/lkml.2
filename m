Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1JMPxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:53:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39003 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab1JMPw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:52:59 -0400
Message-ID: <4E97094F.6050900@zytor.com>
Date: Thu, 13 Oct 2011 08:52:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
References: <1318370975-10817-1-git-send-email-jacob.shin@amd.com> <4E94D4E7.5010001@zytor.com> <20111013095734.GA16748@alberich.amd.com>
In-Reply-To: <20111013095734.GA16748@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 02:57 AM, Andreas Herrmann wrote:
>
> So what is the point in including address space below TOM2 not backed
> with memory in kernel's direct mapping? For similar reserved space
> before 4GB we don't do this.
>
> Instead of barfing, some more constructive feedback would be
> appreciated.
>

Ok, that's a BUG, plain and simple, and a very serious one (for exactly 
the reason you just described.)  We should NEVER have cachable mappings 
for a RESERVED region because it can have arbitrary side effects, so the 
fact that that happens at all is the real problem and it MUST be addressed.

So I'm not arguing that it is not a problem for you (it is a real and 
serious problem), but I would like to see it addressed correctly, which 
is to exclude these memory regions from direct mapping just as we do for 
< 4 GB.  That way the fix applies to any RESERVED region.

	-hpa

