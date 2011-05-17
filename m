Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1EQXda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:33:30 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:8579
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346Ab1EQXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:33:28 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zzbb2dK9371O1432N98dKzz1202hzz8275dhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4DD305B3.3000707@am.sony.com>
Date: Tue, 17 May 2011 16:33:07 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org> <20110517232241.GA19140@kroah.com>
In-Reply-To: <20110517232241.GA19140@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 04:22 PM, Greg KH wrote:
> On Tue, May 17, 2011 at 10:56:03PM +0200, Alessio Igor Bogani wrote:
>> This work was supported by a hardware donation from the CE Linux Forum.
>>
>> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
>> ---
> 
> That's nice, but _why_ do this change?  What does it buy us?
> 
> Please explain why you make a change, not just who sponsored the change,
> that's not very interesting to developers.

Just a note here on the attribution...

Alessio - you can remove the "hardware donation from CELF" line
after the first submission or so.  It doesn't need to be on
every submission of the patch set, and it doesn't need to go into
the commit message for the patch set.  We only want it associated
with the patch set somewhere Google-able (like LKML).

That said, I can answer Greg's question.  This is to speed up
the symbol resolution on module loading.  The last numbers I
saw showed a reduction of about 15-20% for the module load
time, for large-ish modules.  Of course this is highly dependent
on the size of the modules, what they do at load time, and how many
symbols are looked up to link them into the kernel.

Alessio - do you have any timings you can share for the speedup?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

