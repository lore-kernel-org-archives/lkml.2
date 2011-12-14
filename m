Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab1LNW6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:58:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358Ab1LNW6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:58:30 -0500
Message-ID: <4EE92A0C.2040207@zytor.com>
Date: Wed, 14 Dec 2011 14:58:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
References: <1323896791-10858-1-git-send-email-mjg@redhat.com> <1323896791-10858-4-git-send-email-mjg@redhat.com> <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com> <20111214223950.GA29264@srcf.ucam.org> <4EE926D2.3030803@zytor.com> <20111214225728.GA29582@srcf.ucam.org>
In-Reply-To: <20111214225728.GA29582@srcf.ucam.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 02:57 PM, Matthew Garrett wrote:
> On Wed, Dec 14, 2011 at 02:44:34PM -0800, H. Peter Anvin wrote:
>> On 12/14/2011 02:39 PM, Matthew Garrett wrote:
>>>> What are your thoughts on _not_ wrapping efi_variable with
>>>> extended_efi_variable, and instead just using a
>>>> "internal_efi_variable" structure that we copy stuff into/outof.  I
>>>> think that would make the memory management for dealing with the
>>>> different sizes a lot easier to follow.
>>>
>>> Hm. I think that'd only work if we expose a new interface. Writes would 
>>> be easy enough to handle, but reads still need to work for old apps.
>>>
>>
>> Would making the old ABI readonly and add a new write interface resolve
>> the problem with compat mode?
> 
> Yes, but we'd break existing userspace.
> 

Obviously.  However, you indicated above that that might be acceptable
-- how many things use this ABI to set variables?

	-hpa

