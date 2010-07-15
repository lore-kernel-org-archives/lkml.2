Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326Ab0GOSzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:55:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33957 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934137Ab0GOSzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:55:13 -0400
Message-ID: <4C3F5972.2030600@zytor.com>
Date: Thu, 15 Jul 2010 11:54:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
References: <4C3E363B.7060804@goop.org> <4C3E5637.4010300@redhat.com> <4C3E5C8C.8000800@goop.org> <b6d9e574-daf5-4aaa-b76e-4a7e66d0fa97@email.android.com> <4C3F1C84.8080503@goop.org>
In-Reply-To: <4C3F1C84.8080503@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 07:34 AM, Jeremy Fitzhardinge wrote:
> On 07/14/2010 06:29 PM, H. Peter Anvin wrote:
>> Yes, it will definitely NOT be pruned.  I'm going to file a gcc documentation request to see if any of this is actually needed, though.  There may also be a need for gcc to handle *inbound* general memory constraints.
>>   
> 
> You mean "depends on all prior memory updates"?  We have been relying on
> "memory" to do that (barrier(), for example), but it would be nice to
> explicitly confirm that's OK, or get something which is guaranteed to be OK.
> 

No, we haven't.  You're misunderstanding what a "memory" clobber does.
A clobber affects the output side only, but doesn't inherently provide
ordering on the input side.  Apparently this is implicit in "asm
volatile", which is a very important property.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

