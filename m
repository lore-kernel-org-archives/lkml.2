Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1EQSct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:32:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36742 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab1EQScs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:32:48 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: Greg KH <greg@kroah.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 18 May 2011 00:02:00 +0530
Subject: RE: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Topic: [PATCH v4 08/11] tty: add pruss SUART driver
Thread-Index: AcwTiHq1rqtz8W63SmezM9rwWiWDYABN8A+A
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CF13FC2@dbde02.ent.ti.com>
References: <78EB813416554F1A973EF20AA714ADF8@subhasishg>
In-Reply-To: <78EB813416554F1A973EF20AA714ADF8@subhasishg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 10:47:18, Subhasish Ghosh wrote:
> Hi Sekhar,
> 
> >>> Say, if the driver is loaded as a module.
> >>> If I allocate the sram in the platform code, how to I
> >>> free it when the driver is unloaded. 
> >> 
> >> This is what I said in my last e-mail. What is
> >> the issue you see with this approach?
> >> 
> >> | Thanks for the clarification. In this case, the driver
> >> | should use platform callbacks to get/put fast fifo
> >> | space. In case this callback is not populated by the
> >> | platform or returns an error, the driver should fall
> >> | back to allocating from DDR.
> >> 
> > 
> > ok, so what you are suggesting is that I implement some
> > callbacks (like .fifo_alloc, .fifo_dealloc) which can allocate
> > memory using sram_alloc.
> > My doubt is, if already such API's are there (by Russel) or you
> > are suggesting to implement them.
> 
> I can add the fifo_alloc/dealloc as part of the suart platform_data,
> Is that's what you are suggesting. If you may please point me out 
> to any example. I am just not clear with this. 

Yes, that's what I am suggesting. I don't have an exact example
for you, but for an example of how function pointers can be passed
along in platform data you can look at the platform data for
DA8x FB driver in include/video/da8xx-fb.h.

Hope that helps.

Thanks,
Sekhar

