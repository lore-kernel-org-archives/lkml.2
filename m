Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1FTTvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:51:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33377 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1FTTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:51:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Containers <containers@lists.osdl.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        David Lamparter <equinox@diac24.net>, linux-kernel@vger.kernel.org
References: <20110521093936.GA3015@p183> <m11uzsxdty.fsf@fess.ebiederm.org>
	<20110521223054.GA3198@p183> <m1vcx3r3o5.fsf@fess.ebiederm.org>
	<20110523014303.GA2351982@jupiter.n2.diac24.net>
	<20110523014751.GB2351982@jupiter.n2.diac24.net>
	<m1wrgkavbm.fsf_-_@fess.ebiederm.org>
	<m1mxhgav9c.fsf_-_@fess.ebiederm.org>
	<20110620160656.GB16444@mail.hallyn.com>
Date: Mon, 20 Jun 2011 12:50:57 -0700
In-Reply-To: <20110620160656.GB16444@mail.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 20 Jun 2011 11:06:56 -0500")
Message-ID: <m1ei2o5ljy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX184uBF8oSK3Ji6N4VXIgEGbjjltZgf6c4M=
X-SA-Exim-Connect-IP: 98.207.153.68
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
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] proc: Usable inode numbers for the namespace file descriptors.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> Assign a unique proc inode to each namespace, yielding an
>> identifier that userspace can use for identifying a namespace.
>> 
>> This has been a long requested feature and only blocked because
>> a naive implementation would put the id in a global space and
>> would ultimately require having a namespace for the names of
>> namespaces, making migration and certain virtualization tricks
>> impossible.
>> 
>> We still don't have per superblock inode numbers for proc, which
>> appears necessary for application unaware checkpoint/restart and
>> migrations (if the application is using namespace filedescriptors)
>> but that is now allowd by the design if it becomes important.
>> 
>> I have preallocated the ipc and uts initial proc inode numbers so
>> their structures can be statically initialized.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> I've not looked at the setns patches enough, but from what I can see
> here it looks good.
>
> Acked-by: Serge Hallyn <serge@hallyn.com>

Thanks.

There are bugs in my existing proc bits that I am working on fixing so
this second patch will have a small update, before it gets merged.

But posting the patches I was looking for a little review and I was
announcing I had solved the technical problem of how we talk about
namespaces, without needing to introduce another namespace for
namespaces.

Eric
