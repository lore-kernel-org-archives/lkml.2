Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0DUULH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:11:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57111 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab0DUULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:11:05 -0400
Date: Wed, 21 Apr 2010 21:10:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ipmi: Only register one si per bmc
Message-ID: <20100421201048.GA25030@srcf.ucam.org>
References: <1271788828-10231-1-git-send-email-mjg@redhat.com> <1271788828-10231-2-git-send-email-mjg@redhat.com> <4BCF3F69.3050003@acm.org> <20100421182154.GA16436@srcf.ucam.org> <4BCF5A09.80404@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF5A09.80404@acm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 03:03:21PM -0500, Corey Minyard wrote:

> However, IBM makes some systems that can plug together for scalability.   
> Each individual system has a BMC, and when you plug them together into  
> an SMP system, all the BMCs are still there.  At least that's how I  
> understand it.  I'm not sure if the other BMCs become satellite MCs in  
> that case, which would be legit, sort of.  So I guess the answer to you  
> question would be: "Yes, the world is not compatible with the spec".

Hm. Ok. In that case we seem to be in a difficult position - we're not 
supposed to register multiple SIs per BMC, but we're also not supposed 
to send anything other than GetDeviceID to an SI before we decide to use 
it. The options here would seem to be to disambiguate by either 
registering all SIs of a type (on the assumption that if we have 
multiple BMCs, they'll all present their SIs in the same way, and we 
won't have multiple SIs of the same type if we don't have multiple 
BMCs), or taking a risk on that bit of the spec by getting the GUID for 
each SI.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
