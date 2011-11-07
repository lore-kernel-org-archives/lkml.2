Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1KGVg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:36:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40869 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab1KGVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:36:56 -0500
Date: Mon, 7 Nov 2011 21:36:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
Message-ID: <20111107213623.GA29304@srcf.ucam.org>
References: <20111107203752.GA27875@srcf.ucam.org>
 <4EB8436B.20603@zytor.com>
 <20111107204839.GA28261@srcf.ucam.org>
 <4EB84644.8060102@zytor.com>
 <20111107205859.GA28681@srcf.ucam.org>
 <4EB84734.3070006@zytor.com>
 <20111107210702.GA28781@srcf.ucam.org>
 <4EB84BAD.6030707@zytor.com>
 <20111107212328.GA29090@srcf.ucam.org>
 <4EB84EC9.1000104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB84EC9.1000104@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:34:01PM -0800, H. Peter Anvin wrote:
> On 11/07/2011 01:23 PM, Matthew Garrett wrote:
> > 
> > I know. But we also have to handle being called after 
> > ExitBootServices(). There are going to be people who don't want to deal 
> > with signing their kernel builds.
> >  
> 
> Could you clarify why these two are connected?

You can't execute anything unsigned until after ExitBootServices() has 
been called. Otherwise your bootloader is also a malware loader, and 
your signature probably gets blacklisted.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
