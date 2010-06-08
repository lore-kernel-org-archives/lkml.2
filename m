Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0FHVJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:09:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44759 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab0FHVJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:09:08 -0400
Message-ID: <4C0EB168.5080801@zytor.com>
Date: Tue, 08 Jun 2010 14:08:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: jacob pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>	<m1631ue5ho.fsf@fess.ebiederm.org>	<20100607225010.342e2fab@jacob-laptop>	<m1631tfh1i.fsf@fess.ebiederm.org> <4C0EA9BD.1090306@zytor.com> <m1iq5tckb1.fsf@fess.ebiederm.org>
In-Reply-To: <m1iq5tckb1.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 01:59 PM, Eric W. Biederman wrote:
> 
> No.  There is no reason to loose 16 IDT entries indefinitely.  We may
> need a boot time allocation when we see we have isa irqs, to replace
> the static allocation that we have.  But for the most part we dynamically
> idt entries aka vector numbers today, and there is no reason we can't
> generalize that in the future.
> 

Well, that boot time allocation is one of the things
legacy_pic->nr_legacy_irq is used for, and it really makes sense, I
think.  I would really like to move away from a compile-time allocation,
and I still find it hard to believe it has a reason to exist.

	-hpa

