Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0DVWmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:42:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0DVWl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:41:58 -0400
Message-ID: <4BD0CFC1.2060907@zytor.com>
Date: Thu, 22 Apr 2010 15:37:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/5] Add second memory region for crash kernel
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com> <m1aasvkupc.fsf@fess.ebiederm.org>
In-Reply-To: <m1aasvkupc.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 03:07 PM, Eric W. Biederman wrote:
> 
> Have you tried loading a 64bit vmlinux directly into a higher address
> range?  There may be a bit or two missing but you should be able to
> load a linux kernel above 4GB.  I tested the basics of that mechanism
> when I made the 64bit relocatable kernel.
> 
> I don't buy the argument that there is a direct connection between
> the amount of memory you have and how much memory it takes to dump it.
> Even an indirect connections seems suspicious.
> 

We actually have a 64-bit entry point even in bzImage; it is at offset
+0x200 from the 32-bit entry point.  Right now that offset is not
exported anywhere, but it has been stable for a very long time... at
least for as far back as the decompressor has been 64 bits.

The interface to the 64-bit code is by necessity wider, since there is
no such thing as paging off in 64-bit mode, but it probably isn't *too*
hard to figure out how page tables need to be set up in order to work
properly.  At that point, it would be good to document it.

	-hpa
