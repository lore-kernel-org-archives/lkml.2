Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1KUNJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:09:22 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:58412 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1KUNJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:09:20 -0500
Date: Mon, 21 Nov 2011 14:09:16 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111121130916.GA11136@nomi.cz>
References: <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz> <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz> <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz> <20111121130527.GA4010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121130527.GA4010@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 21, 2011 at 02:05:28PM +0100, Stanislaw Gruszka wrote:
> The farther we get the problem is more and more strange.
> 
> Device that write to wrong address, would generate:
> 
> DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
> DMAR:[fault reason 05] PTE Write access is not set

And that's exactly what happens if I don't disable firewire-ohci, because of
that stupid Ricoh multifunction blah blah issue.

> But only if
> 
> PCI-DMA: Using DMAR IOMMU
> 
> was printed in dmesg before. DMAR can be disabled by graphics
> driver, or maybe by other drivers too. Then above print will
> be missed in dmesg and protection would not work.
> 
> Try "dmesg | grep DMAR" to see if DMA remapping is really is
> in use. 

Well, this message is not printed, but as I said, loading firewire-ohci
triggers DMAR faults, so it should be in use anyway.

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
