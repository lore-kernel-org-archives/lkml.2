Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1BBSPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:15:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1BBSPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:15:53 -0500
Date: Wed, 2 Feb 2011 19:59:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
Message-ID: <20110202175944.GC24871@redhat.com>
References: <20110202112139.GD14984@redhat.com>
 <4D4990F8.5020204@zytor.com>
 <20110202172534.GA24871@redhat.com>
 <4D49946D.8010800@zytor.com>
 <20110202173827.GB24871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202173827.GB24871@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 07:38:27PM +0200, Gleb Natapov wrote:
> On Wed, Feb 02, 2011 at 09:29:17AM -0800, H. Peter Anvin wrote:
> > On 02/02/2011 09:25 AM, Gleb Natapov wrote:
> > > According to spec length should be set to 30 on exit.
> > 
> > I don't really know how this comment relates to the code, but in the
> > code I saw a fixed number of bytes being checksummed, which is
> > definitely wrong.
> > 
> What length do you propose to use? If you were referring to
> params->length then it is incorrect since it will be always 30 on exit
> and this has nothing to do with size we need to checksum. Spec defines
> that the sum of bytes 30-73 should be zero. What is definitely wrong
> about this?
> 

Ah I see what length you were referring to params->device_path_info_length.
If we will use that then we will get correct checksum for BIOSes that work
according to phoenix spec too, but edd_show_interface() and edd_show_host_bus()
handle only T13 spec so the information they show can be incorrect. I can
change code to check that params->device_path_info_length == 44 in addition
to checking csum. What do you think?

--
			Gleb.
