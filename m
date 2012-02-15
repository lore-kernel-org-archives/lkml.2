Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2BOTSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:18:09 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44093 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754693Ab2BOTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:18:06 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F3C04E4.4090708@freescale.com>
Date: Wed, 15 Feb 2012 13:17:56 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de>
In-Reply-To: <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 05:57 AM, Alexander Graf wrote:
> 
> On 15.02.2012, at 12:18, Avi Kivity wrote:
> 
>> Well the real reason is we have an extra bit reported by page faults
>> that we can control.  Can't you set up a hashed pte that is configured
>> in a way that it will fault, no matter what type of access the guest
>> does, and see it in your page fault handler?
> 
> I might be able to synthesize a PTE that is !readable and might throw
> a permission exception instead of a miss exception. I might be able
> to synthesize something similar for booke. I don't however get any
> indication on why things failed.

On booke with ISA 2.06 hypervisor extensions, there's MAS8[VF] that will
trigger a DSI that gets sent to the hypervisor even if normal DSIs go
directly to the guest.  You'll still need to zero out the execute
permission bits.

For other booke, you could use one of the user bits in MAS3 (along with
zeroing out all the permission bits), which you could get to by doing a
tlbsx.

-Scott

