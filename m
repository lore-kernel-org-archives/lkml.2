Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0DNOcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab0DNOcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:32:07 -0400
Message-ID: <4BC5D19A.8000605@redhat.com>
Date: Wed, 14 Apr 2010 17:30:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Ralf Baechle <ralf@linux-mips.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
References: <20100406133026.GD20577@parisc-linux.org> <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com> <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org> <20100326175827.GD20055@linux-mips.org> <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org> <17213.1271245760@redhat.com>
In-Reply-To: <17213.1271245760@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 02:49 PM, David Howells wrote:
> Matthew Wilcox<matthew@wil.cx>  wrote:
>
>    
>> I don't know whether we can get it /documented/, but the architect I
>> asked said "We'll never get away with reverting to the older behavior,
>> so in essence the architecture is set to not overwrite."
>>      
> Does that mean we can rely on it?  Linus?
>    

Even if Intel processors behave that way, other processors (real and 
emulated) use those manuals as a specification.  Emulated processors are 
unlikely to touch an undefined register, but real processors may.

(qemu tcg appears not to touch the output)

-- 
error compiling committee.c: too many arguments to function

