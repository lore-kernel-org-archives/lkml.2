Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1AUJ1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:27:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61059 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab1AUJ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j651S3qdhG/oIID7hWZA9nK9ujiCtGp91wnIEaZU2EAodiriEKyQFQrZl52jAEhWMW
         LlJEbSQB3SDMO7uR1rsdbZuket3eRQ5FW1X3MtBu35AI2gNul5jdr2T7zIfAiNy1GTCp
         KgFMugUqUpYk7ylxogL6lFBBQ/t1ZCrCSInOU=
Date: Fri, 21 Jan 2011 01:27:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: Kevin McNeely <Kevin.McNeely@cypress.com>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Henrik Rydberg <rydberg@euromail.se>, Alan Cox <alan@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v4 3/3] 3/3 spi: Cypress TTSP G3 SPI Device Driver
Message-ID: <20110121092739.GB24214@core.coreip.homeip.net>
References: <kev@cypress.com>
 <1294188847-24728-3-git-send-email-kev@cypress.com>
 <20110112184550.GB9168@core.coreip.homeip.net>
 <FB9C2CB29A07AB45B575A4E8D2AABC0901490D54@labamba.mis.cypress.com>
 <4D38182B.60803@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D38182B.60803@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 04:40:35PM +0530, Trilok Soni wrote:
> Hi Dmitry,
> 
> On 1/13/2011 12:32 AM, Kevin McNeely wrote:
> > Hi Dmitry,
> > 
> > Thank you for your review.
> > 
> > Will the existing patches get into the current merge?
> > 
> > Can I revisit this discussion as part of our plan to provide a Protocol
> > B driver?
> > 
> > Thanks and best regards,
> > Kevin
> > 
> 
> Any updates on Kevin's question here?
> 

Hi Trilok, Kevin,

Ah, sorry, was not feeling well last week and lost track of this driver.

No, I am sorry, bit the driver is not quite ready to be merged. Aside of
SPI abort/timeout issues we also have cyttsp_close() implementation
busted (once you close device you lose irq) and bunch of other things I
need to look over. I also have concern about having protocol A now and
upgrading to protocol B: clients that only understand protocol A will
get broken at A->B transition. I think we should consider implementing B
right away for mainline (no, I do not want A/B config options).

Sorry for being slow with doing full review...

Thanks.

-- 
Dmitry
