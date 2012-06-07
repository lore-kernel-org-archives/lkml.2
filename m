Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2FGHto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:49:44 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:31383 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab2FGHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:49:42 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dI9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh668h839hd25he5bhf0ah)
X-WSS-ID: 0M58LQQ-02-2G0-02
X-M-MSG: 
Message-ID: <4FD05CED.60905@amd.com>
Date: Thu, 7 Jun 2012 09:49:01 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120404 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>, <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86, AMD: Fix crash as Xen Dom0 on AMD Trinity systems
References: <1338562358-28182-1-git-send-email-bp@amd64.org> <1338562358-28182-4-git-send-email-bp@amd64.org> <4FCFD2EE.8060508@zytor.com> <20120607072159.GB9856@aftab.osrc.amd.com>
In-Reply-To: <20120607072159.GB9856@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 09:21 AM, Borislav Petkov wrote:
> On Wed, Jun 06, 2012 at 03:00:14PM -0700, H. Peter Anvin wrote:
>> On 06/01/2012 07:52 AM, Borislav Petkov wrote:
>>> From: Andre Przywara<andre.przywara@amd.com>
>>>
>>> f7f286a910221 ("x86/amd: Re-enable CPU topology extensions in case BIOS
>>> has disabled it") wrongfully added code which used the AMD-specific
>>> {rd,wr}msr variants for no real reason.
>>>
>>> This caused boot panics on xen which wasn't initializing the
>>> {rd,wr}msr_safe_regs pv_ops members properly.
>>>
>>> This, in turn, caused a heated discussion leading to us reviewing all
>>> uses of the AMD-specific variants and removing them where unneeded
>>> (almost everywhere except an obscure K8 BIOS fix, see 6b0f43ddfa358).
>>>
>>> Finally, this patch switches to the standard {rd,wr}msr*_safe* variants
>>> which should've been used in the first place anyway and avoided unneeded
>>> excitation with xen.
>>>
>>> Signed-off-by: Andre Przywara<andre.przywara@amd.com>
>>> Cc: Andreas Herrmann<andreas.herrmann3@amd.com>
>>> Cc: stable@vger.kernel.org # 3.4+
>>> Link:<http://lkml.kernel.org/r/1338383402-3838-1-git-send-email-andre.przywara@amd.com>
>>> [Boris: correct and expand commit message]
>>> Signed-off-by: Borislav Petkov<borislav.petkov@amd.com>
>>
>> Why -stable?  I though we had agreed that we didn't have an active
>> problem (unclean hack, yes, but not an active problem) in 3.4/3.5 as it
>> currently sits?

This is probably a leftover from the original patch, before Konrad's 
patch got committed.

> Yes, AFAICT, we need at least one fix for 3.4 where the original patch
> f7f286a910221 broke xen.
>
> So either this one or 1ab46fd319bc should be backported to stable, if
> I'm not mistaken. If the second, I'll drop the stable tag from this one
> and resend.
>
> Konrad, what do you want wrt xen paravirt nullptr breakage for
> 3.4-stable?

Greg just sent out the review mail for 1ab46fd319bc, so we can drop the 
stable tag from this one.

Regards,
Andre.

-------- Original Message --------
Subject: [ 21/82] x86, amd, xen: Avoid NULL pointer paravirt references
Date: Thu, 7 Jun 2012 13:03:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>, 
<alan@lxorguk.ukuu.org.uk>, Andre Przywara <andre.przywara@amd.com>, "H. 
Peter Anvin" <hpa@zytor.com>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad@darnok.org>

commit 1ab46fd319bcf1fcd9fb6311727d532b580e4eba upstream.

Stub out MSR methods that aren't actually needed.  This fixes a crash
as Xen Dom0 on AMD Trinity systems.  A bigger patch should be added to
remove the paravirt machinery completely for the methods which
apparently have no users!
.....



-- 
Andre Przywara
AMD-OSRC (Dresden)
Tel: x29712

