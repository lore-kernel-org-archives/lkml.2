Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894Ab2KHVDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:03:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48798 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789Ab2KHVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:03:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
References: <1351780159.15708.17.camel@falcor>
	<20121101144304.GA15821@redhat.com>
	<20121101145225.GB10269@srcf.ucam.org>
	<20121102132318.GA3300@redhat.com> <87boffd727.fsf@xmission.com>
	<20121105180353.GC28720@redhat.com> <87mwyv96mn.fsf@xmission.com>
	<20121106193419.GH4548@redhat.com> <87k3tynvc0.fsf@xmission.com>
	<20121108194050.GB27586@redhat.com>
	<20121108194522.GC27586@redhat.com>
Date: Thu, 08 Nov 2012 13:03:17 -0800
In-Reply-To: <20121108194522.GC27586@redhat.com> (Vivek Goyal's message of
	"Thu, 8 Nov 2012 14:45:22 -0500")
Message-ID: <87vcdfn6y2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19245BS2IClP5BQ5V6Dik+UDfVqswAAC1I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0060]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Kdump with signed images
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Nov 08, 2012 at 02:40:50PM -0500, Vivek Goyal wrote:
>> On Tue, Nov 06, 2012 at 03:51:59PM -0800, Eric W. Biederman wrote:
>> 
>> [..]
>> 
>> Thnking more about executable signature verification, I have another question.
>> 
>> While verifyign the signature, we will have to read the whole executable
>> in memory. That sounds bad as we are in kernel mode and will not be killed
>> and if sombody is trying to execute a malformed exceptionally large
>> executable, system will start killing other processess. We can potentially
>> lock all the memory in kernel just by trying to execute a signed huge
>> executable. Not good.
>> 
>
> Also, even if we try to read in whole executable, can't an hacker modify
> pages in swap disk and then they will be faulted back in and bingo hacker
> is running its unsigned code. (assuming root has been compromised otherwise
> why do we have to do all this exercise).

You make a decent case for an implicit mlockall(MCL_FUTURE) being
required of signed executables, that are going to be granted privileges
based on signature verification.

As for size if the executable won't fit in memory, there is no point in
checking the signature.

It should be fairly straight forward to make the signature checking
process preemptable and killable.

Of course this is all hand waving at this point.

Eric

