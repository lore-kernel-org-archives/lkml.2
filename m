Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1D2KR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 06:17:58 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:41021 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab1D2KR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 06:17:56 -0400
Message-ID: <4DBA902F.2080009@st.com>
Date: Fri, 29 Apr 2011 15:47:19 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 2/7] dmaengine/dw_dmac: Replace spin_lock* with	irqsave
 variants
References: <cover.1303896566.git.viresh.kumar@st.com> <50dc2f47f2c9f94fce78583568830a66af49307d.1303896567.git.viresh.kumar@st.com> <20110428171020.GB17290@n2100.arm.linux.org.uk> <20110429091557.GZ17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110429091557.GZ17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 02:45 PM, Russell King - ARM Linux wrote:
> BTW, how this gets handled in other drivers is basically as follows in
> the tasklet:
> 
> tasklet()
> {
> 	LIST_HEAD(completed);
> 
> 	spin_lock_irqsave(lock, flags);
> 	for each txd(txd) {
> 		if (completed(txd))
> 			list_move_tail(&txd->node, &completed);
> 	}
> 	try to start new txd();
> 	spin_unlock_irqrestore(lock, flags);
> 
> 	for each list entry safe(txd, &completed) {
> 		void (*callback)(void *) = txd->callback;
> 		void *param = txd->callback_param;
> 
> 		free_txd(txd);
> 
> 		if (callback)
> 			callback(param);
> 	}
> }
> 
> I'm not sure how easy it is to move dw_dmac to that kind of structure,

I will check that.

-- 
viresh
