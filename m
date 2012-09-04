Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab2IDVOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:14:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43021 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2IDVOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:14:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-8-git-send-email-mjg@redhat.com>
	<87txvdzgur.fsf@xmission.com> <20120904202205.GA28903@srcf.ucam.org>
Date: Tue, 04 Sep 2012 14:13:54 -0700
In-Reply-To: <20120904202205.GA28903@srcf.ucam.org> (Matthew Garrett's message
	of "Tue, 4 Sep 2012 21:22:05 +0100")
Message-ID: <87r4qhwkx9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/2vk76sC2Fg1giAAXjUgJfCoWTARh6z4Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Tue, Sep 04, 2012 at 01:13:32PM -0700, Eric W. Biederman wrote:
>> 
>> Matthew Garrett <mjg@redhat.com> writes:
>> 
>> > kexec could be used as a vector for a malicious user to use a signed kernel
>> > to circumvent the secure boot trust model. In the long run we'll want to
>> > support signed kexec payloads, but for the moment we should just disable
>> > loading entirely in that situation.
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> This makes no sense.  The naming CAP_SECURE_FIRMWARE is attrocious,
>> you aren't implementing or enforcing secure firmware.
>
> I'm certainly not attached to the name, and have no problem replacing 
> it.
>
>> You don't give any justification for this other than to support some
>> silly EFI feature.  Why would anyone want this if we were not booting
>> under EFI?
>
> Well, given that approximately everyone will be booting under EFI within 
> 18 months, treating it as a niche case seems a little short sighted.

If we are all going to be using the code we need to keep the code
quality high.

> And 
> secondly, there are already several non-EFI platforms that want to enact 
> a policy preventing root from being able to arbitrarily replace the 
> kernel. Given that people are doing this in the wild, it makes sense to 
> move towards offering that policy in the mainline kernel.

Either this code makes sense without an appeal to EFI or this code makes
no sense.

It is fine for jumping through the EFI trusted boot hoops to be your
motivation, but EFI policy should not be the justification for kernel
implementation details.

There may be some sense to the desired functionality.  From what I have
seen of the policies so far I have no respect for the way people are
using EFI secure boot.  I have no expectation that EFI secure boot will
stop malware as long as anything signed by microsoft's key is trusted by
the firmware.  We have already seen malware in the wild that could be
verified with Microsoft's key.

So please rework this to come from an angle that makes sense all by
itself.

Eric


