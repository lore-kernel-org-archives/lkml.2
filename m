Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0JASzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:55:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36109 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab0JASzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:55:00 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 1 Oct 2010 13:54:37 -0500
Subject: RE: [PATCH] scatterlist: define SG chain for arm architecture
Thread-Topic: [PATCH] scatterlist: define SG chain for arm architecture
Thread-Index: Acthh0+fCMSToqvQT0CTL/CsWJR/TgAEIrYA
Message-ID: <496565EC904933469F292DDA3F1663E602F46545F2@dlee06.ent.ti.com>
References: <1285950521-8093-1-git-send-email-x0095840@ti.com>
 <20101001163958.GA22533@n2100.arm.linux.org.uk>
In-Reply-To: <20101001163958.GA22533@n2100.arm.linux.org.uk>
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

 

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
> Sent: Friday, October 01, 2010 11:40 AM
> To: Guzman Lugo, Fernando
> Cc: linux-arm-kernel@lists.infradead.org; 
> Hiroshi.DOYU@nokia.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scatterlist: define SG chain for arm architecture
> 
> On Fri, Oct 01, 2010 at 11:28:41AM -0500, Fernando Guzman Lugo wrote:
> > Define SG chain for ARM architecture in order to work with big 
> > buffers. This patch is needed in order to iovmm users can 
> pass a big 
> > buffer to map it and ARM architecture has not issues using SG chain.
> > 
> > This change was suggested by FUJITA Tomonori.
> 
> Have you audited all places where SG lists are used in the 
> ARM architecture to ensure that SG chain support is safe?  
> (That goes for ARM generic code and ARM specific drivers.)

Unfortunately I only can test on omap platform. I am not so
Familiar with scatter gather code and what is the restriction
For one page size of SG list (maybe they can comment). However
For SG chaining seems there is no restriction with the exception
Of using the with function to assigned to page and iterate each
Element of the list and it has sometime when SG chaining was 
Introduce all the code should be use this new functions.

I am agree with you about make sure nothing is broken with the change.
Maybe some people of other arm platforms can comment if they have
Issues with the patch and test the change and if there is no complain
Then merge the change. If there are issues maybe I can send the patch
Just for omap platform. However, looks like there is no issues enabling
It to all arm, but again I am not so familiar with SG, so I will let
The experts to comment.

Thanks a lot,
Fernando.




> 
> If the answer is no, this patch is unacceptable until such a 
> review has been carried out.
> 