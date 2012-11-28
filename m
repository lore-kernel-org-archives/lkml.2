Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2K1KLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:11:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45368 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab2K1KLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:11:12 -0500
From: "Navada Kanyana, Mukund" <navada@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Thread-Topic: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Thread-Index: AQHNzUn3sp+aSR+ZB0iEZwLUiY4GmZf+nu6AgABlseA=
Date: Wed, 28 Nov 2012 10:11:05 +0000
Message-ID: <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
References: <n> <1354094577-14967-1-git-send-email-navada@ti.com>
 <20121128092924.GJ32691@opensource.wolfsonmicro.com>
In-Reply-To: <20121128092924.GJ32691@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, November 28, 2012 2:59 PM
> To: Navada Kanyana, Mukund
> Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered
> pages across regmap range
> 
> On Wed, Nov 28, 2012 at 02:52:57PM +0530, Mukund Navada wrote:
> >   Page number in some devices increases across regmap ranges since the
> > selector register to choose the page remains the same. So in order to
> > write correct page number, the start_page_num is stored in
> > regmap_range_cfg.
> 
> I'm sorry but I can't understand what this is supposed to do.  The
> current paging code expects pages to be numbered continuously with no
> gaps.  Can you please clarify?
But the page number is expected to increase only till end of range. But in devices like TLV320AIC3256, the page number increases beyond range.

Example:

Pages 0 through Page 1 --> first register range for device configuration. Page 8 through Page 16 --> second range for DSP1 coefficient memory
Page 26 through Page 34 --> third range for DSP2 coefficient memory

Window length of each page is 128. So if we need to correctly write the page number in selector register for second range, start_page_num would be 8. If we did not have start_page_num, it would write 0 to selector register. 
