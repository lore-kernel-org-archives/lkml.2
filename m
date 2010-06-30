Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0F3Spf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:45:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17592 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0F3Spd convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Jun 2010 14:45:33 -0400
Date: Wed, 30 Jun 2010 14:43:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Turner <mattst88@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       rth@twiddle.net, ink@jurassic.park.msu.ru, mcree@orcon.net.nz,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       dri-devel@lists.freedesktop.org, airlied@gmail.com,
       alexdeucher@gmail.com, jglisse@redhat.com
Subject: Re: Problems with alpha/pci + radeon/ttm
Message-ID: <20100630184357.GE16488@phenom.dumpdata.com>
References: <AANLkTinG-5iKW5cigIQHPHRZuAMtG_xY-74XLL6vE5kb@mail.gmail.com>
 <20100622145805R.fujita.tomonori@lab.ntt.co.jp>
 <AANLkTimTOTM8Tt5A7eBVbxcYaGQVn_Q6-9hL8B1B4bjY@mail.gmail.com>
 <20100627130717M.fujita.tomonori@lab.ntt.co.jp>
 <AANLkTim0JbmNLY1yG5MIWhcjM34h4HHVjS58jEobmPO0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTim0JbmNLY1yG5MIWhcjM34h4HHVjS58jEobmPO0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C2B90B5.022B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 12:58:07AM -0400, Matt Turner wrote:
> On Sun, Jun 27, 2010 at 12:20 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Thu, 24 Jun 2010 10:53:52 -0400
> > Matt Turner <mattst88@gmail.com> wrote:
> >
> >> > Seems that the IOMMU can't find 128 pages. It's likely due to:
> >> >
> >> > - out of the IOMMU space (possibly someone doesn't free the IOMMU
> >> >  space).
> >> >
> >> > or
> >> >
> >> > - the mapping parameters (such as align) aren't appropriate so the
> >> >  IOMMU can't find space.
> >> >
> >> >
> >> >> Is this the cause of the bug we're seeing in the report [1]?

For the fun I did:
 cat /tmp/screenlog.0 | grep iommu_arena | wc
  28509  199588 2167164

Which is to say 28509 * 4096 = 116736000. That looks to be about 111MB.

That does not look right when you are trying to allocate 128 pages. You
are sure it is 128 pages? Can you make the ttm_ code print out the total
of pages it is trying to PCI map ? It might also be interesting to see
how many pages the pci_iommu.c has already set aside for other devices.

The BAR is 128MB, but that would have been an ioremap call - and done
much earlier I think.
