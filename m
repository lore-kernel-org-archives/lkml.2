Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2AJMuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:50:18 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:54410 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab2AJMuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:50:17 -0500
Message-ID: <4F0C33A0.6080509@tu-ilmenau.de>
Date: Tue, 10 Jan 2012 13:48:32 +0100
From: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111201 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de> <4EFC3B17.1040601@redhat.com> <4F09001D.1050701@tu-ilmenau.de> <4F096E26.4090201@redhat.com> <4F0C0EBB.3090506@tu-ilmenau.de> <4F0C1369.9070607@redhat.com> <4F0C2C4E.3000703@tu-ilmenau.de> <4F0C3044.7050307@redhat.com>
In-Reply-To: <4F0C3044.7050307@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/12 13:34, Avi Kivity wrote:
> I prepare/adapt everything to the mentioned styles/policy.
> (I'll insert 2 additional ops for getting "cpuid" and "id of vcpu"...)
>>> What do you mean by "id of vcpu"?
>> I mean the number of the corresponding vcpu.
>> (So mostly "vcpu->vcpu_id" ...)
>> It is necessary for "pr_err_ratelimited"-complains, if cpuid-vendor is
>> unknown ...
>> ("Jan 10 12:14:55 thinkrat kernel: [ 4476.484359] kvm: 15680: cpu0
>> unknown vendor - assuming intel")
> It isn't worthwhile - just don't print the vcpu number (the task ID
> contains enough information, and anyway this should be rare to the point
> of never ever happening)
>

The message itself can be user-triggered ("-cpu
core2duo,vendor=StephansQemu"),
but you are right. Normally all cpus got the same cpuid, so it shouln't
interest
which one had the unknown vendor...

...fixing it and then sending...

regards Stephan

-- 
Dipl.-Inf. Stephan Bärwolf
Ilmenau University of Technology, Integrated Communication Systems Group
Phone: +49 (0)3677 69 4130
Email: stephan.baerwolf@tu-ilmenau.de,  
Web: http://www.tu-ilmenau.de/iks

