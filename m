Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1BDUUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:20:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35972 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1BDUUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:20:50 -0500
Message-ID: <4D4C5F88.30506@zytor.com>
Date: Fri, 04 Feb 2011 12:20:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kamal Mostafa <kamal@canonical.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: fix panic when handling "mem={invalid}" param
References: <1296783486-23033-1-git-send-email-kamal@canonical.com>	<AANLkTimDrWESfmSwRSyhenZTwXovKKa4mSC=Y0=j9yPM@mail.gmail.com>	<4D4C5CE1.2090006@zytor.com> <AANLkTi=FwrG43Br3RVNDJ1Z4UJNgfYt6ih=Gv=0HEtG-@mail.gmail.com>
In-Reply-To: <AANLkTi=FwrG43Br3RVNDJ1Z4UJNgfYt6ih=Gv=0HEtG-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 12:19 PM, Yinghai Lu wrote:
>>
>> All he looks at is when the value returned is zero.  It wouldn't be zero
>> for any actual value, including mem=32M.
>>
> 
> when user pass wrong parameter like less 128M, kernel will not boot either.
> Do we need to sanity check for that?
> 

We could check for the value being smaller than the relocated value of
_end.  That is probably the smallest *fixed* value we can assign.

	-hpa

