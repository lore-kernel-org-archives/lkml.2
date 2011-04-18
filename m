Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1DRRjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:39:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab1DRRj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:39:28 -0400
Message-ID: <4DAC7739.2060100@zytor.com>
Date: Mon, 18 Apr 2011 10:39:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
 by alignment
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-2-git-send-email-joerg.roedel@amd.com> <4DAC4E7F.1010502@zytor.com> <20110418145653.GI2192@amd.com> <4DAC5E16.1020408@zytor.com> <20110418173655.GA8155@8bytes.org>
In-Reply-To: <20110418173655.GA8155@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 10:36 AM, Joerg Roedel wrote:
>>
>> The right thing to do for in-place kexec it to turn it off, not rely on
>> any specific magic addresses.  We have had this problem with a number of
>> drivers in the context of kexec.
> 
> Ok, so changing the start-address to zero seems the best thing to do.
> This way the GART will working again on machines with less than 512MB of
> RAM (and a BIOS that does not initialize the GART as we want it).
> 

I'm going to apply your patch as-is, based on the notion that this is a
change of mechanism, and a change of policy is a separate thing.
However, we should address the shutdown of the GART first, and then we
can move the start address to zero (again, two separate patches.)

	-hpa
