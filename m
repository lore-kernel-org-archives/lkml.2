Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2INMwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:52:09 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48619
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365Ab2INMwD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:52:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI9371Ic89bh542M1432Izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd25hf0ah107ah1288h12a5h12a9h12bdh1315h1155h)
X-WSS-ID: 0MACBQG-02-6NT-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: =?iso-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <j.glisse@gmail.com>
CC: Alex Deucher <alexdeucher@gmail.com>,
        "Cherkasov, Dmitrii" <Dmitrii.Cherkasov@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Dmitry Cherkasov <dcherkassov@gmail.com>
Subject: RE: [PATCH] Add 2-level GPUVM pagetables support to radeon driver.
Thread-Topic: [PATCH] Add 2-level GPUVM pagetables support to radeon driver.
Thread-Index: AQHNkbohbxCR13ChM0eTjN3ffFaPTZeI6IKAgAAFfICAAAFXgIAA7LCA///vzxA=
Date: Fri, 14 Sep 2012 12:51:53 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02C432B77@sausexdag03.amd.com>
References: <1347545629-3474-1-git-send-email-Dmitrii.Cherkasov@amd.com>
 <CAH3drwZzMX_6fUkgWMf+vMz9+kyNQs6t3m-1W9aSjDJA2E_qEA@mail.gmail.com>
 <CADnq5_OWLhvmGDaqCPDLk1Q_xpDFi9j4csOsdJ8uwMEV53dm1A@mail.gmail.com>
 <CAH3drwZeW5zEswqcSfFvovBM_SGERCpoW99_G_NabyA1yERrUQ@mail.gmail.com>
 <5052EF8F.1020905@vodafone.de>
In-Reply-To: <5052EF8F.1020905@vodafone.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.181.250.19]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Christian König [mailto:deathsimple@vodafone.de]
> Sent: Friday, September 14, 2012 4:49 AM
> To: Jerome Glisse
> Cc: Alex Deucher; Cherkasov, Dmitrii; linux-kernel@vger.kernel.org; dri-
> devel@lists.freedesktop.org; Deucher, Alexander; Dave Airlie; Dmitry
> Cherkasov
> Subject: Re: [PATCH] Add 2-level GPUVM pagetables support to radeon
> driver.
> 
> On 13.09.2012 20:42, Jerome Glisse wrote:
> > On Thu, Sep 13, 2012 at 2:37 PM, Alex Deucher <alexdeucher@gmail.com>
> wrote:
> >> On Thu, Sep 13, 2012 at 2:17 PM, Jerome Glisse <j.glisse@gmail.com>
> wrote:
> >>> On Thu, Sep 13, 2012 at 10:13 AM, Dmitry Cherkasov
> >>> <dcherkassov@gmail.com> wrote:
> >>>> PDE/PTE update code uses CP ring for memory writes.
> >>>> All page table entries are preallocated for now in alloc_pt().
> >>>>
> >>>> It is made as whole because it's hard to divide it to several patches
> >>>> that compile and doesn't break anything being applied separately.
> >>>>
> >>>> Tested on cayman card.
> >>>>
> >>>> Signed-off-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
> >>>> ---
> >>>> I couldn't test in on SI card, so would be happy if someone could check
> it there.
> >>> I wonder how this could have work as you don't set
> >>> PAGE_TABLE_BLOCK_SIZE field so each page directory entry cover only 1
> >>> page.
> >> I think PAGE_TABLE_BLOCK_SIZE refers number of 4k pages used for PTE
> >> entries per PDE.  E.g., 1 4k page contains 512 64 bit PTEs. so if
> >> BLOCK_SIZE is set to 1 page, each PDE points to 1 page (4k) or PTE
> >> entries.  If BLOCK_SIZE is 2, each PDE points to 2 pages (8k) or PTEs,
> >> etc.
> >>
> >> Alex
> >>
> > If so then it's ok
> Yeah, minor nitpick: BLOCK_SIZE seems to be number of 4k pages in a page
> directory entry minus 1.
> 
> So with a BLOCK_SIZE of 0 you get one 4K page and with a BLOCK_SIZE of 1
> you get 8K, etc...

It's LOG2:

PAGE_TABLE_BLOCK_SIZE 	27:24 	0x0 	log2 number of pages in page table block (default = 1 page)

> 
> Christian.


