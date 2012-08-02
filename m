Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2HBRAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:00:38 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:12418 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab2HBRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:00:36 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432Izz1202hzzz2fh2a8h668h839h93fhd25hf0ah107ah)
Message-ID: <501AB2C8.9010805@am.sony.com>
Date: Thu, 2 Aug 2012 10:03:04 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
CC: Richard Weinberger <richard@nod.at>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "Heinz.Egger@linutronix.de" <Heinz.Egger@linutronix.de>,
        "thomas.wucher@linutronix.de" <thomas.wucher@linutronix.de>,
        "shmulik.ladkani@gmail.com" <shmulik.ladkani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Marius.Mazarel@ugal.ro" <Marius.Mazarel@ugal.ro>,
        "nyoushchenko@mvista.com" <nyoushchenko@mvista.com>
Subject: Re: UBI fastmap updates
References: <1341836323-43916-1-git-send-email-richard@nod.at>  <1343916747.25013.112.camel@sauron.fi.intel.com>  <20120802161512.5ac7a303@spider.haslach.nod.at>  <1343917741.25013.114.camel@sauron.fi.intel.com>  <20120802165132.1bf1e5d7@spider.haslach.nod.at>  <1343924267.25013.156.camel@sauron.fi.intel.com>  <20120802183210.7076aa48@spider.haslach.nod.at> <1343925930.25013.163.camel@sauron.fi.intel.com>
In-Reply-To: <1343925930.25013.163.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-FOPE-CRA-Verdict: 160.33.194.230$ugal.ro%0%1%am.sony.com%False%False%0$
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 09:45 AM, Artem Bityutskiy wrote:
> Richard,
> 
> On Thu, 2012-08-02 at 18:32 +0200, Richard Weinberger wrote:
>>> This should not happen. Fastmap should _reserve_ enough of PEBs for it
>>> to operate. It should always find the PEB to write.
>>
>> What is the benefit?
>> IOW what is wrong with the current approach?
> 
> Several reasons. The main is: fastmap will start consuming PEBs reserved
> for volumes when the amount of available PEBs is just enough to map all
> LEBs. This will break UBI liability.

I'm don't understand what "UBI liability" is.  Can you please clarify?
What breaks if the PEBs get consumed?

> 
>> Why?
>> If everything goes wrong, fastmap makes sure that no fastmap is on
>> flash.
>> In case of a powercut we fall back to scanning mode.
>> R/O mode is overkill IMHO.
> 
> So can I interpret this the following way. Not only fastmap give no
> guarantees that it exists after an unclean reboot, it does not even give
> guarantees that it exists after a clean reboot.
> 
> Unless I am confused, the fastmap design is over-simplified.

Fastmap is an optimization.  Maybe I'm missing something, but
I'm not sure why, if the optimization stopped working, you
would want to reduce the functionality of the file system.

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

