Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2JVUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:33:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36023 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2JVUdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:33:43 -0400
Message-ID: <5085AD7D.106@zytor.com>
Date: Mon, 22 Oct 2012 13:33:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, len.brown@intel.com, fenghua.yu@intel.com,
        vgoyal@redhat.com, grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6> <20121016043528.20003.601.stgit@localhost6.localdomain6> <873916i88t.fsf@xmission.com> <5085A9A8.5020004@zytor.com> <87fw56fduo.fsf@xmission.com>
In-Reply-To: <87fw56fduo.fsf@xmission.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:31 PM, Eric W. Biederman wrote:
>>
>> IIRC Fenghua experimented with that and it didn't work.  Not all BIOSes
>> use that bit to determine BSP-ness.
> 
> What does a BIOS have to do with anything?
> 
> The practical issue here is does an INIT IPI cause the cpu to go into
> startup-ipi-wait or to start booting at 4G-16 bytes.
> 
> For dealing with BIOSen we may still need to use the bootstrap processor
> for firmware calls, cpu suspend, and other firmware weirdness, but that
> should all be completely orthogonal to the behavior to what happens
> when an INIT IPI is sent to the cpu.
> 
> The only firmware problem I can imagine having is cpu virtualization
> bug.
> 

The whole problem is that some BIOSes go wonky after receiving an INIT
(as in INIT-SIPI-SIPI) to the BSP.

	-hpa
