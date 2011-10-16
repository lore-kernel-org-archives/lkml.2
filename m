Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1JSVga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:36:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41354 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1JSVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:36:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Kyle Moffett <kyle@moffetthome.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
References: <20111011013201.GA7948@thunk.org>
	<20111011020530.GG16723@count0.beaverton.ibm.com>
	<20111011032523.GB7948@thunk.org> <m1ty7ghvvn.fsf@fess.ebiederm.org>
	<203BBB0D-293D-4BFB-A57B-41C56F58F9B3@mit.edu>
	<m17h4bfcuv.fsf@fess.ebiederm.org>
	<20111012175702.GA23231@fieldses.org>
	<CAGZ=bqJxadNqaPCW3HufrMmQ57x082=pCDa6-mWLsdtfxHgdPw@mail.gmail.com>
	<20111012190452.GA23845@fieldses.org>
	<CAGZ=bqJjgmtBfyXJ2eK1C0PfzkgBVWFTjkTYkC211ZT+-5f-UQ@mail.gmail.com>
	<20111014155406.GC13119@thunk.org> <m17h478n5k.fsf@fess.ebiederm.org>
	<4E98B088.5030400@zytor.com>
Date: Sun, 16 Oct 2011 02:42:14 -0700
In-Reply-To: <4E98B088.5030400@zytor.com> (H. Peter Anvin's message of "Fri,
	14 Oct 2011 14:58:32 -0700")
Message-ID: <m1ipnpl1c9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+WW47CLu9IMYqqKnYIypnO86DsYc1WFTo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: **
Subject: Re: Detecting if you are running in a container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 10/14/2011 11:04 AM, Eric W. Biederman wrote:
>> 
>> I have found and merged a solution that allows us to name namespaces
>> without needing a namespaces for namespaces.
>> 
>
> Something based on UUIDs, perhaps?
>
> UUIDs are kind of exactly this, after all... a single namespace designed
> to be large and random enough to be globally unique without a central
> registration authority.

mount --bind /proc/self/ns/net /var/run/netns/<name>

When we want to refer to the namespace in syscalls we pass a file
descriptor we received from opening the namespace reference object.

That moves the entire naming problem into the file namespace.

Eric
