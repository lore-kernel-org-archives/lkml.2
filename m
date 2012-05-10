Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424Ab2EJV3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:29:12 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:1816
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758956Ab2EJV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:29:10 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz84d07hz2fh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
Message-ID: <4FAC3336.3010609@am.sony.com>
Date: Thu, 10 May 2012 14:29:26 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: android: logger: Allocate logs dynamically
 at boot (v2)
References: <4FAC302F.2090004@am.sony.com> <20120510212122.GA16432@kroah.com>
In-Reply-To: <20120510212122.GA16432@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 02:21 PM, Greg KH wrote:
> On Thu, May 10, 2012 at 02:16:31PM -0700, Tim Bird wrote:
>> +	log->misc.minor = MISC_DYNAMIC_MINOR;
>> +	log->misc.name = kstrdup(log_name, GFP_KERNEL);
>> +	if (log->misc.name == NULL) {
>> +		ret = -1;
>> +		goto out_free_log;
> 
> Please return a "real" error number, not just -1.  You do this a few
> times in this function, -EINVAL perhaps?  -1 is -EPERM, which is not
> what you want to be saying here, right?

You're right.  This is only called by init code now, which doesn't
look at the return value (only checks for non-zero), but the intent
is to change this going forward, so a real error number is called for.

These are all memory allocation failures, so I'm thinking of using
-ENOMEM.  Would that be right?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

