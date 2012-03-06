Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2CFHAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:00:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36268 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab2CFHAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:00:36 -0500
Message-ID: <4F55B5F7.6060502@zytor.com>
Date: Mon, 05 Mar 2012 23:00:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: zhenzhong.duan@oracle.com, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        joe.jin@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Initialize max_pfn_mapped as initial ident mapping size
 for x86_64
References: <1330669703-20176-1-git-send-email-zhenzhong.duan@oracle.com> <CAE9FiQV3CyB1YRPDxFu-jGr73+Qwpkn4O4QYYZvBJcyZA5Gouw@mail.gmail.com> <4F556D3D.8040400@zytor.com> <CAE9FiQVU8fafCEZrRPADMYubvncxT+0FGdWVPuu0M=O8NYaCYw@mail.gmail.com>
In-Reply-To: <CAE9FiQVU8fafCEZrRPADMYubvncxT+0FGdWVPuu0M=O8NYaCYw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 10:27 PM, Yinghai Lu wrote:
> 
>>
>> The early mapping range we can fix, and probably should.  Mapping the
>> first 4 GiB is not a lot of memory and makes a much more sensible
>> starting point.
> 
> do you mean map the 4G in head_64.S?
> 

Yes.  It would be better to design the mapping system so that it would
incrementally map everything we need (with page tables allocated out of
the memory already mapped), but that isn't a trivial exercise,
especially with the need to avoid the initramfs, kernel image and
command line and other data elements.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

