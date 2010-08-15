Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0HOPmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:42:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33145 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab0HOPl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TQOW6xA+EWXbpXK8KTEGbJ52cJHBloDAUq0dqbPj3unyR/LO60Jvbm5re3qezHdOdm
         n4StfCF/I/LR0NftcIi4Iyw5u2fOlWjDbxq8h6ai7CHRDmmByZkSy7ImTAHqBsj3jxxz
         MNb8HfPreFkYOMSORQAcqCyqe4snpJQ7+APa8=
Date: Sun, 15 Aug 2010 12:30:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Don't write io_apic ID if it is not changed
Message-ID: <20100815083057.GB5629@lenovo>
References: <4C66FEA9.3040303@kernel.org> <20100815082446.GA5629@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100815082446.GA5629@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 12:24:46PM +0400, Cyrill Gorcunov wrote:
...
> As far as I see, this was done by a purpose in former code. Consider the
> situation when mp_ioapics[apic_id].apicid >= get_physical_broadcast().
> By code flow (io_apic.c:2099) this set
> 
> 		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
> 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
> 				apic_id, mp_ioapics[apic_id].apicid);
> 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
> 				reg_00.bits.ID);
> --->			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
> 		}
> 
> So with your patch we always hit "continue" without real changing of ID which
> is not correct.
> 
> But perhaps I miss something?
> 
> 	-- Cyrill

False alarm Yinghai, of course there is no need to write same value back,
sorry for noise.

	-- Cyrill
