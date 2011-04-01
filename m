Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1DAXwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:52:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:58950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1DAXwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:52:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,285,1299484800"; 
   d="scan'208";a="904697903"
Date: Sat, 2 Apr 2011 01:52:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110401235239.GE29397@sortiz-mobl>
References: <20110202195417.228e2656@queued.net>
 <20110202200812.3d8d6cba@queued.net>
 <20110331230522.GI437@ponder.secretlab.ca>
 <20110401112030.GA3447@sortiz-mobl>
 <20110401104756.2f5c6f7a@debxo>
 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 11:56:35AM -0600, Grant Likely wrote:
> On Fri, Apr 1, 2011 at 11:47 AM, Andres Salomon <dilinger@queued.net> wrote:
> > On Fri, 1 Apr 2011 13:20:31 +0200
> > Samuel Ortiz <sameo@linux.intel.com> wrote:
> >
> >> Hi Grant,
> >>
> >> On Thu, Mar 31, 2011 at 05:05:22PM -0600, Grant Likely wrote:
> > [...]
> >> > Gah.  Not all devices instantiated via mfd will be an mfd device,
> >> > which means that the driver may very well expect an *entirely
> >> > different* platform_device pointer; which further means a very high
> >> > potential of incorrectly dereferenced structures (as evidenced by a
> >> > patch series that is not bisectable).  For instance, the xilinx ip
> >> > cores are used by more than just mfd.
> >> I agree. Since the vast majority of the MFD subdevices are MFD
> >> specific IPs, I overlooked that part. The impacted drivers are the
> >> timberdale and the DaVinci voice codec ones.
> 
> Another option is you could do this for MFD devices:
> 
> struct mfd_device {
>         struct platform_devce pdev;
>         struct mfd_cell *cell;
> };
> 
> However, that requires that drivers using the mfd_cell will *never*
> get instantiated outside of the mfd infrastructure, and there is no
> way to protect against this so it is probably a bad idea.
> 
> Or, mfd_cell could be added to platform_device directly which would
> *by far* be the safest option at the cost of every platform_device
> having a mostly unused mfd_cell pointer.  Not a significant cost in my
> opinion.
I thought about this one, but I had the impression people would want to kill
me for adding an MFD specific pointer to platform_device. I guess it's worth
giving it a try since it would be a simple and safe solution.
I'll look at it later this weekend.

Thanks for the input.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
