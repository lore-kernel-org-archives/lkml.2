Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1D0GAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:00:11 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:53648 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab1D0GAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:00:09 -0400
Message-ID: <4DB7B0D5.5050504@st.com>
Date: Wed, 27 Apr 2011 11:29:49 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>
Subject: Re: [PATCH 1/6] dmaengine/dw_dmac: Replace spin_lock_bh with	irqsave
 variants
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com> <4DAD2AE9.7060106@st.com> <20110426203306.GC17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110426203306.GC17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 02:03 AM, Russell King - ARM Linux wrote:
> On Tue, Apr 19, 2011 at 11:55:45AM +0530, viresh kumar wrote:
>> This must have been added in dw_dma_chan instead :(
>> Will resend it.
> 
> Even that doesn't work.  It has to be a local variable.

Hello,

There are two kinds of locks taken in dw_dmac: spin_lock_bh and spin_lock.
spin_lock_bh is taken from routines called from external drivers and spin_lock
taken inside tasklet.
For reasons mentioned earlier, spin_lock_bh has to be replaced with spin_lock_irqsave.

Now, Is simple spin_lock() sufficient inside tasklet?? As dma API's can be called
from interrupt context (which will try to take spin_lock_irqsave).

I think spin_lock must be replaced with irqsave variants, even in tasklet.
Now if we do that, do we need this tasklet at all??

-- 
viresh
