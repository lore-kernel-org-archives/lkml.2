Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1BCKEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab1BCKEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:04:12 -0500
Date: Thu, 3 Feb 2011 12:04:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
Message-ID: <20110203100403.GV14984@redhat.com>
References: <20110202112139.GD14984@redhat.com>
 <4D4990F8.5020204@zytor.com>
 <20110202172534.GA24871@redhat.com>
 <4D49946D.8010800@zytor.com>
 <20110202173827.GB24871@redhat.com>
 <20110202175944.GC24871@redhat.com>
 <4D49B707.8000003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D49B707.8000003@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 11:56:55AM -0800, H. Peter Anvin wrote:
> On 02/02/2011 09:59 AM, Gleb Natapov wrote:
> > 
> > Ah I see what length you were referring to params->device_path_info_length.
> > If we will use that then we will get correct checksum for BIOSes that work
> > according to phoenix spec too, but edd_show_interface() and edd_show_host_bus()
> > handle only T13 spec so the information they show can be incorrect. I can
> > change code to check that params->device_path_info_length == 44 in addition
> > to checking csum. What do you think?
> > 
> 
> Yes, you need to check both.
OK.

> 
> This is really a union of two similar-but-not-identical structures
> distinguished by the length field.
> 
Yes, unfortunately phoenix spec lacks some vital information that is
needed to find the device edd entry corresponds too. SCSI target or IDE
channel for instance.
 
--
			Gleb.
