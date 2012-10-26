Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2JZDay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:30:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60322 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2JZDaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:30:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
References: <871ugqb4gj.fsf@xmission.com> <20121023131854.GA16496@redhat.com>
	<20121023145920.GD16496@redhat.com> <87fw552mb4.fsf_-_@xmission.com>
	<20121024173651.GE1821@redhat.com> <1351145401.18115.78.camel@falcor>
	<20121025141048.GD9377@redhat.com> <1351190421.18115.92.camel@falcor>
	<20121025185520.GA17995@redhat.com>
	<1351214158.18115.186.camel@falcor>
	<20121026023916.GA16762@srcf.ucam.org>
Date: Thu, 25 Oct 2012 20:30:37 -0700
In-Reply-To: <20121026023916.GA16762@srcf.ucam.org> (Matthew Garrett's message
	of "Fri, 26 Oct 2012 03:39:16 +0100")
Message-ID: <87625xq59e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+P0bm+UnF0kPjNz767FDnbF4ODxuSjizs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1745]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Matthew Garrett <mjg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Kdump with signed images
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> writes:

> On Thu, Oct 25, 2012 at 09:15:58PM -0400, Mimi Zohar wrote:
>
>> On a running system, the package installer, after verifying the package
>> integrity, would install each file with the associated 'security.ima'
>> extended attribute.  The 'security.evm' digital signature would be
>> installed with an HMAC, calculated using a system unique key. 
>
> The idea isn't to prevent /sbin/kexec from being modified after 
> installation - it's to prevent it from being possible to install a 
> system that has a modified /sbin/kexec. Leaving any part of this up to 
> the package installer means that it doesn't solve the problem we're 
> trying to solve here. It must be impossible for the kernel to launch any 
> /sbin/kexec that hasn't been signed by a trusted key that's been built 
> into the kernel, and it must be impossible for anything other than 
> /sbin/kexec to make the kexec system call.

The 'security.capability' attribute modulo weirdness with the security
bounding set gives us the necessary tools to allow /sbin/kexec to make
the system call.

The primary trick with this is to limit the installer in such as way
that we can trust the installer even on a system on which root has been
compromised.

Trusting the installer is the same class of problem as trusting
/sbin/kexec, and to me a much more interesting problem as it keeps
critical system files from being tampered with.

It sounds like there are some tricky details to work through but this
direction of system integrity looks like it is worth pursuing,
regardless of how we handle a signed /sbin/kexec.

Eric
