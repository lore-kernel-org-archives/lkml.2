Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1DHHkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:40:43 -0400
Received: from thoth.sbs.de ([192.35.17.2]:31108 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab1DHHkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:40:42 -0400
Message-ID: <4D9EBBC3.2040803@siemens.com>
Date: Fri, 08 Apr 2011 09:39:47 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>	<4D9847BC.9060906@redhat.com>	<4D98716D.9040307@codemonkey.ws>	<4D9873CD.3080207@redhat.com>	<20110406093333.GB6465@elte.hu>	<4D9E6F6E.9050709@codemonkey.ws> <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
In-Reply-To: <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-08 07:14, Pekka Enberg wrote:
> Hi Anthony,
> 
> On Fri, Apr 8, 2011 at 5:14 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>> If someone was going to seriously go about doing something like this, a
>> better approach would be to start with QEMU and remove anything non-x86 and
>> all of the UI/command line/management bits and start there.
>>
>> There's nothing more I'd like to see than a viable alternative to QEMU but
>> ignoring any of the architectural mistakes in QEMU and repeating them in a
>> new project isn't going to get there.
> 
> Hey, feel free to help out! ;-)
> 
> I don't agree that a working 2500 LOC program is 'repeating the same
> architectural mistakes' as QEMU. I hope you realize that we've gotten
> here with just three part-time hackers working from their proverbial
> basements. So what you call mistakes, we call features for the sake of
> simplicity.
> 
> I also don't agree with this sentiment that unless we have SMP,
> migration, yadda yadda yadda, now, it's impossible to change that in
> the future. It ignores the fact that this is exactly how the Linux
> kernel evolved and the fact that we're aggressively trying to keep the
> code size as small and tidy as possible so that changing things is as
> easy as possible.

I agree that it's easy to change 2kSomething LOC for this. But if you
now wait too long designing in essential features like SMP, a scalable
execution model, and - very important - portability (*), it can get
fairly painful to fix such architectural deficits later on. How long did
it take for Linux to overcome the BKL? QEMU is in the same unfortunate
position.

Jan

(*) I would consider Anthony's idea to drop anything !=x86 a mistake
given where KVM is moving to, today on PPC, tomorrow likely on ARM -
just to name two examples.

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
