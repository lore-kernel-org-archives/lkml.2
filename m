Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940Ab2COOhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:37:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56865 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761902Ab2COOhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:37:00 -0400
Message-ID: <4F61FE7E.9060600@zytor.com>
Date: Thu, 15 Mar 2012 07:36:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
References: <1331819798-1955-1-git-send-email-mjg@redhat.com> <4F61F5E6.8060509@zytor.com> <20120315140708.GA3395@srcf.ucam.org> <4F61FA14.6020203@zytor.com> <20120315142445.GA4357@srcf.ucam.org> <4F61FC8E.8070109@zytor.com> <20120315143308.GA4382@srcf.ucam.org>
In-Reply-To: <20120315143308.GA4382@srcf.ucam.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 07:33 AM, Matthew Garrett wrote:
>>
>> If we map it WB software can do speculative loads from that region which
>> would bring it into the cache.  If we map it UC we might have to CLFLUSH...
> 
> We've already mapped it at this point - we then go back and flag it UC 
> if it's not writeback. The latter seems to be causing problems, I'm not 
> sure we've seen any indication that the former is. And these regions are 
> marked as runtime accessible, so per spec they do need to be mapped into 
> address space...
> 

In other words, it's totally f*cked.  I guess at that point mapping it
WB and letting the BIOS-configured MTRRs deal with the caching
attributes is probably the right thing to do.

I would still really like to understand why we're seeing #MCs... that's
bothersome all by itself.

	-hpa
