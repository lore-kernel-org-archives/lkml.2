Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab2COO2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:28:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56799 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab2COO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:28:40 -0400
Message-ID: <4F61FC8E.8070109@zytor.com>
Date: Thu, 15 Mar 2012 07:28:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
References: <1331819798-1955-1-git-send-email-mjg@redhat.com> <4F61F5E6.8060509@zytor.com> <20120315140708.GA3395@srcf.ucam.org> <4F61FA14.6020203@zytor.com> <20120315142445.GA4357@srcf.ucam.org>
In-Reply-To: <20120315142445.GA4357@srcf.ucam.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 07:24 AM, Matthew Garrett wrote:
> On Thu, Mar 15, 2012 at 07:17:56AM -0700, H. Peter Anvin wrote:
>> On 03/15/2012 07:07 AM, Matthew Garrett wrote:
>>>
>>> I have a report of a system that fails to boot with an MCE during EFI 
>>> setup. The memory range is marked reserved and claims not to support any 
>>> caching type, which I think probably translates as "Don't do anything to 
>>> this region ever".
>>>
>>
>> In other words, "don't map me"... not something we really support at the
>> moment, but perhaps we should; at least until we find systems in the
>> field that break with that constraint :(
> 
> Mapping should be harmless as long as we then don't touch it? I can't 
> think of any circumstances where we would.
> 

If we map it WB software can do speculative loads from that region which
would bring it into the cache.  If we map it UC we might have to CLFLUSH...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

