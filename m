Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0KHWPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:15:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57938 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab0KHWPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y1Bc+TkRJInBoNuuA5z3E4awO8m7YyVRDTU9X5duHb9+mUeAGHXue4xKYWEMpMyC4W
         Np7OkQYqGv0PaDIxCNhxO3Ze4LrAs19oHyzg9jhZsFHQXsqDKHYfamqAnm60p+6oRalO
         68dtto4XLaEvWm4zQAiq0zT+U19uLryiMXpsQ=
Date: Tue, 9 Nov 2010 01:15:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings v2
Message-ID: <20101108221528.GH6273@lenovo>
References: <1289251229-19589-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.00.1011082238420.2900@localhost6.localdomain6> <87oc9zqy0l.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oc9zqy0l.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:57:30PM +0100, Andi Kleen wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > On Mon, 8 Nov 2010, Andi Kleen wrote:
> >>  static inline u32 native_apic_msr_read(u32 reg)
> >>  {
> >> -	u32 low, high;
> >> +	u32 low;
> >>  
> >>  	if (reg == APIC_DFR)
> >>  		return -1;
> >>  
> >> -	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
> >> -	return low;
> >> +	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
> >> +	return (u32)low;
> >
> > What's the point of casting u32 to u32 ?
> 
> One of the earlier reviewers thought adding an explicit cast would make
> the truncation in the code clearer.  I didn't full agree either, but 
> still did the change.
> 
> -Andi

Well, Andi I proposed to define variable as u64 and convert it back to u32 at procedure
exit point. That would be clean, and I still think so ;) Though I'm fine with
either way (I just thought about ones who will be reading this code in future,
and since most the rdmsrl callers already use u64 and unsigned long, this would
be consistent as well).

  Cyrill
