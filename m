Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2KCDCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 23:02:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2KCDCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 23:02:44 -0400
MIME-Version: 1.0
In-Reply-To: <20121102143603.GD3300@redhat.com>
References: <20121026023916.GA16762@srcf.ucam.org>
	<20121026170609.GB24687@redhat.com>
	<1351276649.18115.217.camel@falcor>
	<20121101131003.GA14573@redhat.com>
	<20121101135356.GA15659@redhat.com>
	<1351780159.15708.17.camel@falcor>
	<20121101144304.GA15821@redhat.com>
	<20121101145225.GB10269@srcf.ucam.org>
	<20121102132318.GA3300@redhat.com>
	<CAKTCnzkQwhWGJRTiuxv8wp7uPDFoT6eGsN0k51Bvw8=EqQFW=w@mail.gmail.com>
	<20121102143603.GD3300@redhat.com>
Date: Sat, 3 Nov 2012 08:32:42 +0530
Message-ID: <CAKTCnzn9RpN9Sg36iJSCRdn1fqUmdxgs-gF6oAdxohPA7Vs1iw@mail.gmail.com>
Subject: Re: Kdump with signed images
From: Balbir Singh <bsingharora@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 8:06 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 02, 2012 at 07:59:15PM +0530, Balbir Singh wrote:
>> On Fri, Nov 2, 2012 at 6:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Nov 01, 2012 at 02:52:25PM +0000, Matthew Garrett wrote:
>> >> On Thu, Nov 01, 2012 at 10:43:04AM -0400, Vivek Goyal wrote:
>> >>
>> >> > So I think this does satisfy the requirement matthew specified. Isn't it?
>> >> > Matthew, what do you think?
>> >>
>> >> Sure, if you can ensure that. You'll need to figure out how to get the
>> >> build system to sign the userspace binaries and you'll need to ensure
>> >> that they're statically linked and don't dlopen anything (including the
>> >> nsswitch modules), but otherwise that should work.
>> >>
>> >
>> > [ CC peter jones ]
>> >
>> > Ok, so even if we build kexec-tools statically with glibc, we have the
>> > issue of name service switch modules. glibc will still do dlopen on
>> > these modules. So what are options now.
>> >
>> > - Sign glibc and associated shared libraries. Do not allow unsigned
>> >   shared library to dynamically link with signed executable.
>> >
>> > - Peter mentioned that work with uClibc for kexec-tools.
>> >
>> > I personally think that however hard it is but first option sounds like
>> > a long term solution. We might have more user space processes which
>> > we might have to trust a generic solution will help with that. For example,
>> > we might have to sign and trust qemu at some point of time.
>> >
>> > Are there other ways of handing glibc issue?
>> >
>>
>> Have you seen http://sourceware.org/glibc/wiki/FAQ - "Even statically
>> linked programs need some shared libraries which is not acceptable for
>> me. What can I do?" Probably, worth trying.
>
> Yes I have seen this. IIUC, it says that build libc with -enable-static-nss
> and then individual programs need to statically build against the nss
> modules program will use.
>
> I think building libc with -enable-static-nss part will be unacceptable
> for general server as other programs would like to make use of the
> existing nss functionality.

No, use that library for static linking only for programs that need to
be signed (kexec-tools), until the base OS gets signature support. Why
does the same library need to be used for general sever programs? The
built library would be used only on the build system.

I also like HPA's suggestion on using klibc, but I am not sure what it
would take to port the tools to use klibc

Balbir
