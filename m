Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab0JFSdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:33:44 -0400
Received: from mail.atheros.com ([12.19.149.2]:46819 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab0JFSdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:33:42 -0400
Date: Wed, 6 Oct 2010 11:33:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Marcel Holtmann <holtmann@linux.intel.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: Re: RFC: btusb firmware load help
Message-ID: <20101006183340.GI7070@tux>
References: <1286349552.6145.11.camel@aeonflux>
 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
 <1286380566.6145.42.camel@aeonflux>
 <20101006163816.GE7070@tux>
 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
 <20101006173949.GG7070@tux>
 <1286387660.3655.382.camel@jlt3.sipsolutions.net>
 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
 <1286389697.3655.401.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286389697.3655.401.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:28:17AM -0700, Johannes Berg wrote:
> On Wed, 2010-10-06 at 11:26 -0700, Luis R. Rodriguez wrote:
> 
> > > Good idea, I forgot about possible firmware changes :) Lets see if our
> > > team can do that. Thanks for all the feedback.
> > 
> > Deepak a proof of concept test can involve simply hex-editing the
> > ath3k-1.fw and replacing 0x3002 to 0x3003, then the above patch might
> > work.
> 
> $ hd ath3k-1.fw
> ...
> 00000670  00 00 00 00 00 00 00 00  00 00 00 00 f3 0c 02 30  |...............0|
> 00000680  12 01 10 01 e0 01 01 40  f3 0c 02 30 01 00 00 00  |.......@...0....|
> ...
> 
> that looks a lot like the IDs right there, in little endian :-)

Furthermore another idea by johannes is that if we cannot fix this
in firmware by changing the exposed device ID, we could just check
in btusb for some USB component that would come alive once the firmware
does get loaded, like endpoints, or speed, or whatever. But that would
be last resort.

  Luis
