Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0LVTDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 14:03:33 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59226 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0LVTDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 14:03:32 -0500
Message-ID: <4D124B80.9040401@sgi.com>
Date: Wed, 22 Dec 2010 11:03:28 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>,
        Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Early kernel messages are overflowing the static log buffer
References: <4D06B317.2090608@sgi.com> <20101222130946.GC13412@elte.hu> <20101222131719.GA8061@htj.dyndns.org> <4D1249ED.9040008@sgi.com>
In-Reply-To: <4D1249ED.9040008@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



...
>> Yeap, with percpu allocator now mostly stable, I don't think the
>> message needs to be KERN_INFO anymore.  I'll change it to KERN_DEBUG.
>>
>> Thanks.
>>
> 
> This doesn't really help the log buffer overflow problem as KERN_DEBUG
> messages still end up in the buffer.  The pr_debug() macro does compile
> out the messages if the system does not have KERNEL debug set, though
> distros also have this set as a default.

Btw, I meant to add that the my patchset allocates the log buffer right
after boot mem is setup.  So this output does not affect the overflow
problem, though it is nice to clean up the console output whenever we can.
