Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab2EWT0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:26:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab2EWT0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:26:03 -0400
Message-ID: <4FBD39BE.8040101@zytor.com>
Date: Wed, 23 May 2012 12:25:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <4FBB7185.6040105@redhat.com> <alpine.LFD.2.02.1205221919260.3231@ionos> <4FBCFDD1.5050405@redhat.com> <alpine.LFD.2.02.1205232037220.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205232037220.3231@ionos>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 11:37 AM, Thomas Gleixner wrote:
>>
>> That works, but replaces one problem with another: now we have two
>> sources for the same data, and need to juggle between them depending on
>> register number (either synchronizing in both directions, or special
>> casing); so you're simplifying one thing at the expense of the other.
>> If the microcode starts accessing more registers, then having two
>> layouts becomes even uglier.
> 
> Fair enough :)

Yes, the µcode accessing this data structure directly probably falls
under the category of a legitimate need to stick to the hardware format.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

