Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1AJEG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 23:06:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43011 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1AJEGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 23:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m9ztDS5StZF42IdWuCzpKZ1NBrfqxOPawFV5BHXGl4gPovW0lUrH3txOrulgKEM4gD
         1vi89yGfDTaevdw/ccubyDV+L2tCzBoLbDCWKucDIa5Jd5CKtMhVHfM+IkunTHVDDQzU
         LW4ww8Ab9cuXE+n8qR8QQ7FMrEyGQV5qjCxkM=
MIME-Version: 1.0
In-Reply-To: <4D2A00C2.904@gmail.com>
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
	<20110109093926.GB542@elte.hu>
	<AANLkTik=bg0KY8Oygxem+SdEaPHwBtHRHOcz29HSReHH@mail.gmail.com>
	<4D2A00C2.904@gmail.com>
Date: Mon, 10 Jan 2011 10:06:21 +0600
Message-ID: <AANLkTinM0P90w6tRaogEm1S6o3Prb3DFHNgqgmVTLh+H@mail.gmail.com>
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 12:38 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 01/09/2011 07:57 PM, Rakib Mullick wrote:
>> On Sun, Jan 9, 2011 at 3:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  When nr_cpus=n passed from command line and there is N > n physical cpu
> present we *still* have to increment disabled_cpus in generic_processor_info
> because:
>
> 1) We're priting out the number of cpu which is disabled
> 2) total_cpus become inconsistent
>
> and while (1) is not that important, total_cpus _is_ important (it
> is used to print out offlined cpus).
>
When we use nr_cpus=n, it works as an upper limit. If there are any
other CPUs beyond that limit those are not counted and we couldn't put
them back on work. So, when we couldn't use hotpluging feature to back
them into work, should we care about them?


>  So I still fail to see why we need to drop the former increment in
> first place.
> --
>    Cyrill
>
