Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1FAG5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab1FAG46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:56:58 -0400
Message-ID: <4DE5E29E.7080009@redhat.com>
Date: Wed, 01 Jun 2011 09:56:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Brad Campbell <lists2009@fnarfbargle.com>
CC: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <4DE44333.9000903@fnarfbargle.com> <20110531054729.GA16852@liondog.tnic> <4DE4B432.1090203@fnarfbargle.com> <20110531103808.GA6915@eferding.osrc.amd.com> <4DE4FA2B.2050504@fnarfbargle.com> <alpine.LSU.2.00.1105311517480.21107@sister.anvils> <4DE589C5.8030600@fnarfbargle.com> <20110601011527.GN19505@random.random> <alpine.LSU.2.00.1105312120530.22808@sister.anvils> <4DE5DCA8.7070704@fnarfbargle.com>
In-Reply-To: <4DE5DCA8.7070704@fnarfbargle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 09:31 AM, Brad Campbell wrote:
> On 01/06/11 12:52, Hugh Dickins wrote:
>
>>
>> I guess Brad could try SLUB debugging, boot with slub_debug=P
>> for poisoning perhaps; though it might upset alignments and
>> drive the problem underground.  Or see if the same happens
>> with SLAB instead of SLUB.
>
> Not much use I'm afraid.
> This is all I get in the log
>
> [ 3161.300073] 
> =============================================================================
> [ 3161.300147] BUG kmalloc-512: Freechain corrupt
>
> The qemu process is then frozen, unkillable but reported in state "R"
>
> 13881 ?        R      3:27 /usr/bin/qemu -S -M pc-0.13 -enable-kvm -m 
> 1024 -smp 2,sockets=2,cores=1,threads=1 -nam
>
> The machine then progressively dies until it's frozen solid with no 
> further error messages.
>
> I stupidly forgot to do an alt-sysrq-t prior to doing an alt-sysrq-b, 
> but at least it responded to that.
>
> On the bright side I can reproduce it at will.

Please try slub_debug=FZPU; that should point the finger (hopefully at 
somebody else).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

