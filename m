Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0H0VWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:22:01 -0400
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:34448 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0H0VV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:21:56 -0400
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 17:21:56 EDT
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyle Moffett <kyle@moffetthome.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Fri, 27 Aug 2010 15:51:58 -0500
Subject: Re: [PATCH 2/2] sky2: Add unidirectional fiber link support
Thread-Topic: [PATCH 2/2] sky2: Add unidirectional fiber link support
Thread-Index: ActGKbT0xZAfVYOlRXWABcjWBAeT5w==
Message-ID: <81DAD951-0909-4D3A-8451-AEE3F9B07054@boeing.com>
References: <1282938138-17844-1-git-send-email-Kyle.D.Moffett@boeing.com><12
 82938138-17844-3-git-send-email-Kyle.D.Moffett@boeing.com>
 <20100827133825.494b8098@nehalam>
In-Reply-To: <20100827133825.494b8098@nehalam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.500.1024-17600.001
X-TM-AS-Result: No--21.915000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 27, 2010, at 16:38, Stephen Hemminger wrote:
> On Fri, 27 Aug 2010 15:42:18 -0400 Kyle Moffett <Kyle.D.Moffett@boeing.com> wrote:
>> +	/* 
>> +	 * Once interrupts are reenabled, reset the PHY again to make sure
>> +	 * that we didn't miss a link-up interrupt.  This is especially
>> +	 * likely to occur if we're in fiber-txonly mode, as a link-up
>> +	 * interrupt is generated almost immediately after we finish
>> +	 * programming the PHY.
>> +	 */
>> +	sky2_phy_reinit(sky2);
> 
> Won't this cause a renegotiation causing up to 2 second delay?

Well, I suppose that's possible, but we've only just reset and enabled the PHY moments before, so I don't see where you could get an *extra* 2-second delay.  On the other hand, I suppose it would be much nicer if there was an easy way to fake an extra interrupt there instead of reinitializing the whole PHY.  I'm not all that comfortable with my understanding of the interrupt logic in the sky2 driver, so I figured I would just reuse all the necessary locking from sky2_phy_reinit().

Do you have any comments or criticisms of the particular "duplex" method of configuring the unidirectional link support?

Cheers,
Kyle Moffett

