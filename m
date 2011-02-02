Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1BBVsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:48:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34841 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1BBVsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:48:06 -0500
Message-ID: <4D49D0E6.30102@zytor.com>
Date: Wed, 02 Feb 2011 13:47:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <4D475DB5.1020300@zytor.com> <4D488EB1.9020803@goop.org> <4D49B5F6.5010606@zytor.com> <20110202205704.GA14752@liondog.tnic>
In-Reply-To: <20110202205704.GA14752@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 12:57 PM, Borislav Petkov wrote:
> On Wed, Feb 02, 2011 at 11:52:22AM -0800, H. Peter Anvin wrote:
>> 3. Arguably on native hardware we should still load the microcode into
>> RAM in the boot loader, and install it on the very early CPU bringup
>> path.  That means locking down some (currently) 400K of RAM to handle
>> different combinations of CPUs, or the additional complexity of
>> jettisoning microcode which cannot be used while still be able to deal
>> with hotplug.  I think there is a strong case for this model, which
>> would mean moving the microcode into /boot anyway.
> 
> /me like it, sounds very nifty. So how do we want to do that, we add
> a field to the real-mode kernel header that tells us where to find
> the microcode image and we take it and apply the ucode somewhere in
> do_boot_cpu() path?
> 

We already have a mechanism for passing arbitrary blobs -- the linked
list -- so we don't have to add a new field at all.

	-hpa

