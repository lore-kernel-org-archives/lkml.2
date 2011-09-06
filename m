Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1IFKJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:09:11 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:23310 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1IFKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:09:07 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR3IUX-01-0AY-02
X-M-MSG: 
Date: Tue, 6 Sep 2011 12:08:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [V3][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110906100857.GE14200@erda.amd.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314290748-23569-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.11 12:45:44, Don Zickus wrote:
> +int register_nmi_handler(unsigned int type, nmi_handler_t handler,
> +			unsigned long nmiflags, const char *devname)
> +{
> +	struct nmiaction *action;
> +	int retval;
> +
> +	if (!handler)
> +		return -EINVAL;
> +
> +	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
> +	if (!action)
> +		return -ENOMEM;
> +
> +	action->handler = handler;
> +	action->flags = nmiflags;
> +	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);

Null pointer check is missing here.

> +
> +	retval = __setup_nmi(type, action);
> +
> +	if (retval) {
> +		kfree(action->name);
> +		kfree(action);
> +	}
> +	
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(register_nmi_handler);

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

