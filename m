Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2CXE7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:59:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59728 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2CXE7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:59:00 -0400
Message-ID: <4F6D5481.8050706@zytor.com>
Date: Fri, 23 Mar 2012 21:58:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <201203240402.38749.trenn@suse.de> <4F6D50DD.4050306@zytor.com> <CAE9FiQXvi-HPO+Ct=k0Ga_uaTrntJW=nh-VKnGbXaovFN=zDaQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXvi-HPO+Ct=k0Ga_uaTrntJW=nh-VKnGbXaovFN=zDaQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 09:50 PM, Yinghai Lu wrote:
> On Fri, Mar 23, 2012 at 9:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Can this be implemented without using dynamic memory allocations?
>>> If not, it's not suitable for early APCI overriding.
>>
>> Yes it can, as long as it is uncompressed.  It just becomes a matter of
>> walking the cpio headers which is effectively a linked list.
> 
> During checking in reserve_inirtd() (BTW, the name of the function is outdated).
> memblock is ready.
> So dynamical memory allocation is there already.
> 
> also could put that headers in the tail, so old intird utilities could
> work as before.
> 

We could; I'm not sure if that would be an improvement or not.

However, for the microcode update stuff this needs to happen long before
memblock exists, so it's not really an option.  However, it's not a
problem, as the whole initrd blob needs to be reserved for that duration.

	-hpa


