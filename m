Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0LKB3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 20:29:25 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56159 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0LKB3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 20:29:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>
References: <20101209172027.GA10085@mail.hallyn.com>
	<20101211005044.GA25513@p183.telecom.by>
Date: Fri, 10 Dec 2010 17:29:10 -0800
In-Reply-To: <20101211005044.GA25513@p183.telecom.by> (Alexey Dobriyan's
	message of "Sat, 11 Dec 2010 02:50:44 +0200")
Message-ID: <m1r5dpxfkp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/5GrxslU+MOH5weJWbkYWgDg5euGZp3vk=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 1/4] Add a user_namespace as creator/owner of uts_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Thu, Dec 09, 2010 at 05:20:27PM +0000, Serge E. Hallyn wrote:
>>  struct uts_namespace {
>>  	struct kref kref;
>>  	struct new_utsname name;
>> +	struct user_namespace *user_ns;
>
> You're going to add these to the rest?

That is the idea.

namespaces and other objects of interest will keep a user_ns
pointer referencing the context in which they were created.

I took a quick look and all of the namespaces seem to have capability
checks that we want to allow if you are in the proper context.

What is particularly interesting is that this makes a root user in
something other than the init_user_ns with all capabilities essentially
a normal user because capable(CAP_XXX) becomes capable(&init_user_ns, CAP_XXX).
And as such will always fail except where we have updated the capability
checks.

Eric

