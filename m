Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0LIW6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:58:44 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60956 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0LIW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:58:43 -0500
Date: Thu, 9 Dec 2010 22:58:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Revamp reboot behaviour to match Windows more
	closely
Message-ID: <20101209225833.GA25750@srcf.ucam.org>
References: <1291931204-5854-1-git-send-email-mjg@redhat.com> <4D015741.7090500@zytor.com> <20101209223201.GA23894@srcf.ucam.org> <4D015914.1040009@zytor.com> <20101209223847.GA24452@srcf.ucam.org> <4D015ACF.1050105@zytor.com> <20101209225142.GA25215@srcf.ucam.org> <4D015DEF.9000302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D015DEF.9000302@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:53:35PM -0800, H. Peter Anvin wrote:
> On 12/09/2010 02:51 PM, Matthew Garrett wrote:
>> I'm afraid I don't understand your argument. The date cutoff would be on
>> the order of 2001 (anything after this will have been tested with XP).
>> The spec that defines this behaviour only came into existence in August
>> 2000, and any older hardware will be missing the flag that indicates
>> that this feature is supported. It doesn't seem realistic to believe
>> that there's any real body of hardware that sets the flag but otherwise
>> has a broken implementation.
>>
>
> 2001 is probably a good date, then.
>
> It's pretty safe you'll see the bit being set on systems which are older  
> than that, even if it was not defined at the time it was created -- just  
> being garbage.  That's par for the course in BIOS land.

There's a revision field in the FADT. They'd need to simultaneously 
provide an incorrect revision *and* by pure luck set the 10th bit of a 
32-bit register. Is it possible? Yes. Is it likely? No, and I don't see 
a benefit in adding extra code to force hardware into a less-tested 
configuration.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
