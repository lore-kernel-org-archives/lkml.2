Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2JVUrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:47:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36141 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab2JVUrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:47:51 -0400
Message-ID: <5085B0D0.9020508@zytor.com>
Date: Mon, 22 Oct 2012 13:47:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, len.brown@intel.com, fenghua.yu@intel.com,
        vgoyal@redhat.com, grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6> <20121016043528.20003.601.stgit@localhost6.localdomain6> <873916i88t.fsf@xmission.com> <5085A9A8.5020004@zytor.com> <87fw56fduo.fsf@xmission.com> <5085AD7D.106@zytor.com> <87a9vedyqe.fsf@xmission.com>
In-Reply-To: <87a9vedyqe.fsf@xmission.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:43 PM, Eric W. Biederman wrote:
> 
> The reason the BIOSen go wonky is the INIT cause the cpu to go to the
> reset vector at 4G-16 bytes.  So it is very much expected that the
> BIOSen start acting like you just came out of reset.
> 
> If you can clear bit 8 of IA32_APIC_BASE_MSR and inform the cpu to not
> send the cpu to 4G-16 bytes and instead send the cpu into it's magic
> startup-ipi-wait mode then the BIOSen will not be involved on that path.
> 
> It is a simple question of does the cpu support clearing bit 8
> meaningfully.
> 
> If the cpu allows bit 8 to be cleared and sends the cpu to the reset
> vector on receipt of the INIT IPI I would call that a deviation from the
> x86 cpu specification.
> 
> So clearing bit 8 is not a question about BIOSen it is a question of can
> we avoid the BIOSen, by using an obscure under-documented cpu feature.
> 

As I said, I thought Fenghua tried that but it didn't work, experimentally.

	-hpa

