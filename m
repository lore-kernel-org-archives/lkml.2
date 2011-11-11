Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1KKS6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:58:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52460 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1KKS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:58:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <m1lisj48q1.fsf@fess.ebiederm.org>
	<m1fwir48og.fsf@fess.ebiederm.org> <20111024100735.GL1512@8bytes.org>
	<20111111153148.GC11779@8bytes.org>
Date: Fri, 11 Nov 2011 10:59:33 -0800
In-Reply-To: <20111111153148.GC11779@8bytes.org> (Joerg Roedel's message of
	"Fri, 11 Nov 2011 16:31:48 +0100")
Message-ID: <m11uteo57u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/OqcAp1ebAMtAwd+/qQnySdn+bc+6CbsA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Joerg Roedel <joro@8bytes.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] x86 amd_gart_64: Verify we can perform the remapping requested
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Mon, Oct 24, 2011 at 12:07:36PM +0200, Joerg Roedel wrote:
>> On Mon, Oct 17, 2011 at 02:20:15PM -0700, Eric W. Biederman wrote:
>> > 
>> > Recently I had a driver try with a peculiar 2G dma memory limit.
>> > The driver failed in weird and strange ways because the GART remapping
>> > apperture had been allocated above 2G where the driver cound not reach,
>> > and no error was reported when the mappings were setup.
>> > 
>> > Implement gart_dma_supported to test for this problem case and to return
>> > and error if we can not support the remapping.
>> 
>> You do basically the same as for swiotlb, so it must be good :)
>
> Okay, thinking more about this, I am not so sure anymore it is a really
> good idea to fix it this way. It basically signals the driver that DMA
> is not possible with the device if the aperture does not fit into
> the dma_mask. But DMA within the ZONE_DMA might still work, no?
>
> So I think the right way to fix it is to return a dma-mapping error if
> and only if the address needs to be remapped by the aperture (of swiotlb or
> gart).

Perhaps I am mistaken but since the method is iommu type specific if we
don't actually use the iommu we should not call the method so I think
this is patch is already implementing what you want.

> This still allows the driver to use GFP_DMA allocations.

I definitely agree on that.

Eric
