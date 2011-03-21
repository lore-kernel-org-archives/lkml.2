Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1CUGkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 02:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab1CUGkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 02:40:14 -0400
Message-ID: <4D86F2C2.9080707@redhat.com>
Date: Mon, 21 Mar 2011 14:40:02 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Takao Indoh <tindoh@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Len Brown <lenb@kernel.org>, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
References: <1299766243-494-1-git-send-email-amwang@redhat.com> <20110310143923.GB29464@redhat.com> <m1oc5ig90b.fsf@fess.ebiederm.org> <20110310185019.GB23105@srcf.ucam.org>
In-Reply-To: <20110310185019.GB23105@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, any comments?

Matthew, seems you agree on this patch, may I have your ACK?

Thanks.

于 2011年03月11日 02:50, Matthew Garrett 写道:
> On Thu, Mar 10, 2011 at 09:50:28AM -0800, Eric W. Biederman wrote:
>
>> Move all EFI calls that the kernel does (on x86) into a special section
>> of the bzImage that the bootloader can run.  This works very well for
>> the x86 BIOS and it should also work very well for EFI.  Among other
>> things by having a special 32bit and a special 64bit section this solves
>> the what flavor of EFI problem are we running on problem.
>
> There's no benefit in calling any EFI methods in the kernel if we have
> no intention of making further calls later. If we intent on making
> further calls later then this approach doesn't work well.
>
>> Never perform any EFI calls once the kernel is initialized, last I
>> looked all of the EFI calls that were interesting to perform at runtime
>> were a subset of what ACPI can do, and ACPI is a easier to deal with
>> long term.
>
> With the exception of reboot, I don't see any overlap between the EFI
> runtime services and ACPI.
>
>> Kexec and kdump can easily pass the gather data from the first kernel to
>> the second kernel like we do for the normal bios paramsters today.
>
> Doing that's not a problem. The real problem is that passing a virtual
> map to EFI is a one-shot event. The information we need to provide to
> the second kernel isn't a set of parameters - it's the whole memory map,
> and we need to depend on the kernel to be able to set up the same map
> again.
>
>> As a fly in the ointment that leaves the question of how do we set EFI
>> variables.  It is needed functionality when we are installing, and
>> occasionally nice to have.  But it is a very rare slow path.  I would
>> isolate the EFI after the kernel has booted to exactly to that one case.
>> Either with a special driver or a some flavor of virtualization from
>> userspace like we used to do for video card initialization.
>
> Also capsule updating (not that we implement that at present, but
> vendors will want it). But, again, if you want to push this out to some
> sort of magic then we can just drop pretty much all of the kernel EFI
> support.
>
>> The current design of EFI in the x86 kernel is crap.  We seem to have
>> advanced past the early adopter hack anything together to make it work
>> stage.  So let's stop adding hacks and write something that won't give
>> us a long term support problems.
>
> We're using EFI exactly as it's designed to be used at the moment. The
> only problem is that nobody ever thought people would try to do anything
> like booting one OS into another OS that has different ideas about
> address space layout, but that's a problem with the spec and not our
> implementation.
>

