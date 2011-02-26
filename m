Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1BZICi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 03:02:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1BZICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 03:02:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wjYLIlHECWhExq8KMIp4tk9WJsbUcksDzMDTPcbeUqhA5FShoJFT/SYPcbdNUYPKdR
         Favn5fjyJ9ritp3R3lBm7RtFreHtS4hu11Tp6DWEKUJ+LOQX+dHkBcbUkGNmy3QgLrxm
         3ayLdNQhFZFHXYy6le+9VsN5IsH+b8MuGtVtY=
Message-ID: <4D68B397.6040809@gmail.com>
Date: Sat, 26 Feb 2011 11:02:31 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be processed
 on any CPU
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com> <1294348732-15030-6-git-send-email-dzickus@redhat.com> <alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 05:39 AM, Maciej W. Rozycki wrote:
...
>
>   [Catching up with old e-mail...]
>
>   In line with the comment above that you're removing -- have you (or
> anyone else) adjusted code elsewhere so that external NMIs are actually
> delivered to processors other than the BSP?  I can't see such code in this
> series nor an explanation as to why it wouldn't be needed.
>
>   For the record -- the piece of code above reflects our setup where the
> LINT1 input is enabled and configured for the NMI delivery mode on the BSP
> only and all the other processors have this line disabled in their local
> APIC units.  If system NMIs are to be handled after the removal of the
> BSP, then another processor has to be selected and configured for NMI
> reception.  Alternatively, all local units could have their LINT1 input
> enabled and arbitrate handling, although it would be quite disruptive as
> all the processors would take the interrupt if it happened.  OTOH it would
> be more fault-tolerant in the case of a CPU failure.  On a typical x86 box
> the system NMI cannot be routed to an I/O APIC input.
>
>    Maciej

   Hi Maciej, good catch! The code doesn't reconfig LVT. As just Don pointed
it might be Intel is working on something, dunno. Probably we better should
drop this patch for now (at least until LVT reconfig would not be implemented).

-- 
     Cyrill
