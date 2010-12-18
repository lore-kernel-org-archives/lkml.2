Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0LRGdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 01:33:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37526 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0LRGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 01:33:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <20101217152246.GA8221@mail.hallyn.com>
	<20101217152458.GA11162@mail.hallyn.com>
	<20101217173125.GA29982@kroah.com> <m18vzoryit.fsf@fess.ebiederm.org>
	<20101217195829.GB1410@kroah.com> <m1ipysm8us.fsf@fess.ebiederm.org>
	<20101217231527.GA21227@kroah.com>
Date: Fri, 17 Dec 2010 22:32:52 -0800
In-Reply-To: <20101217231527.GA21227@kroah.com> (Greg KH's message of "Fri, 17
	Dec 2010 15:15:27 -0800")
Message-ID: <m1vd2rlhez.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19sLR1zh7Cda2I5AVSl2mrftVDHft6krWI=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as creator/owner of uts_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Fri, Dec 17, 2010 at 12:40:11PM -0800, Eric W. Biederman wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> >> There are also major benefits to have the version of something that is
>> >> never freed never going away, because it means you can just reference it
>> >> in code.  So while I would be happy to say this is special don't use a
>> >> kref and roll the reference counting logic by hand, we aren't
>> >> dynamically allocating init_uts_ns any time soon.
>> >
>> > Why have a reference count at all if it's not needed or used here?
>> 
>> We have to reference count every other uts namespace.
>
> Ok, that makes sense, then also please dynamically create this one, do
> not create a static kref.

Nope.  It's a bad idea.  It messes up the kernel bootstrap if you do
that, and it makes this one structure different from every other
structure init_task uses.

Eric
