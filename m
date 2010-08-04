Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0HDRte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:49:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:53645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0HDRtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,316,1278313200"; 
   d="scan'208";a="541931215"
Subject: Re: [PATCH] ioat2: catch and recover from broken vtd
 configurations v6
From: David Woodhouse <David.Woodhouse@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkml@chrisli.org" <lkml@chrisli.org>
In-Reply-To: <AANLkTim-otwN3mZZPLNz6s9hH1X+W4F-t93hdVCHNT+e@mail.gmail.com>
References: <20100723224652.25725.36534.stgit@localhost.localdomain>
	 <AANLkTim-otwN3mZZPLNz6s9hH1X+W4F-t93hdVCHNT+e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Wed, 04 Aug 2010 18:49:25 +0100
Message-ID: <1280944165.19499.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:47 -0700, Dan Williams wrote:
> On Fri, Jul 23, 2010 at 3:47 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On some platforms (MacPro3,1) the BIOS assigns the ioatdma device to the
> > incorrect iommu causing faults when the driver initializes.  Add a quirk
> > to catch this misconfiguration and try falling back to untranslated
> > operation (which works in the MacPro3,1 case).
> >
> > Assuming there are other platforms with misconfigured iommus teach the
> > ioatdma driver to treat initialization failures as non-fatal (just fail
> > the driver load and emit a warning instead of triggering a BUG_ON).
> >
> > This can be classified as a boot regression since 2.6.32 on affected
> > platforms since the ioatdma module did not autoload prior to that
> > kernel.
> >
> > Cc: <stable@kernel.org>
> > Cc: David Woodhouse <David.Woodhouse@intel.com>
> > Reported-by: Chris Li <lkml@chrisli.org>
> > Tested-by: Chris Li <lkml@chrisli.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > David, looking for your sign-off to take this final version through my
> > tree.
> 
> Ping.  I'm looking to include this in my 2.6.36 pull request.

Acked-By: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


