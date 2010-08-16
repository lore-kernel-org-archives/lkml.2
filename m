Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0HPJGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:06:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48361 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0HPJGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lG9hCzxxOC5gRbSwncu3D8If2slPgBFpjbhVwUPxxSE7alsKbToZwfvLUqu87RR0JU
         nPjGkFWnNvrLqjFXHY5jDQYD0bZjGgtuu3lTdTLHGQScKlpI/ExriZq6vCd86PWW8vGh
         clPPvYwL6P5fGyJSAbXCqiWmBqTSdwbkFCwEg=
Date: Mon, 16 Aug 2010 13:06:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Don't write io_apic ID if it is not changed
Message-ID: <20100816090645.GA5805@lenovo>
References: <4C66FEA9.3040303@kernel.org> <20100815082446.GA5629@lenovo> <20100815083057.GB5629@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100815083057.GB5629@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 12:30:57PM +0400, Cyrill Gorcunov wrote:
> On Sun, Aug 15, 2010 at 12:24:46PM +0400, Cyrill Gorcunov wrote:
> ...
> > As far as I see, this was done by a purpose in former code. Consider the
> > situation when mp_ioapics[apic_id].apicid >= get_physical_broadcast().
> > By code flow (io_apic.c:2099) this set
> > 
> > 		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
> > 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
> > 				apic_id, mp_ioapics[apic_id].apicid);
> > 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
> > 				reg_00.bits.ID);
> > --->			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
> > 		}
> > 
> > So with your patch we always hit "continue" without real changing of ID which
> > is not correct.
> > 
> > But perhaps I miss something?
> > 
> > 	-- Cyrill
> 
> False alarm Yinghai, of course there is no need to write same value back,
> sorry for noise.
> 
> 	-- Cyrill

Thinking a bit more I guess there might be a sence to write io-apic id
unconditionally, io-apic id is not latched on reset but set to 0 (at least
for old apics) so if we hit id match -- this will be once, but the same
time we will have additional if() for every cycle iteration, not sure
it worth it. Right?

	-- Cyrill
