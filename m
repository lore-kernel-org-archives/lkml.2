Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2KWBfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:35:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49881 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2KWBfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:35:43 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <50AEBF86.50501@citrix.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com> <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com> <87lidwtego.fsf@xmission.com> <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl> <87txshx28b.fsf@xmission.com> <50AE6542.3020302@zytor.com> <50AEBF86.50501@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 22 Nov 2012 17:34:56 -0800
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Message-ID: <a1f75604-1f52-4af1-9dd7-b469ed4ea7b6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok... that *sort of* makes sense, but also underscores how utterly different this is from a normal kexec.

Andrew Cooper <andrew.cooper3@citrix.com> wrote:

>On 22/11/2012 17:47, H. Peter Anvin wrote:
>> The other thing that should be considered here is how utterly 
>> preposterous the notion of doing in-guest crash dumping is in a
>system 
>> that contains a hypervisor.  The reason for kdump is that on bare
>metal 
>> there are no other options, but in a hypervisor system the right
>thing 
>> should be for the hypervisor to do the dump (possibly spawning a
>clean 
>> I/O domain if the I/O domain is necessary to access the media.)
>>
>> There is absolutely no reason to have a crashkernel sitting around in
>
>> each guest, consuming memory, and possibly get corrupt.
>>
>> 	-hpa
>>
>
>(Your reply to my email which I can see on the xen devel archive
>appears
>to have gotten lost somewhere inside the citrix email system, so
>apologies for replying out of order)
>
>The kdump kernel loaded by dom0 is for when Xen crashes, not for when
>dom0 crashes (although a dom0 crash does admittedly lead to a Xen
>crash)
>
>There is no possible way it could be a separate domain; Xen completely
>ceases to function as soon as jumps to the entry point of the kdump
>image.
>
>~Andrew

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
