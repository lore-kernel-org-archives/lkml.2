Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2IWHA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 03:00:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57411 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2IWHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 03:00:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <20120124220247.GA26353@hallyn.com>
	<CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
	<20120124231601.GA4470@sergelap>
	<CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
	<20120128195103.GA11299@sergelap> <87txup763i.fsf_-_@xmission.com>
	<87d31d75yj.fsf_-_@xmission.com>
	<20120923041906.GM13973@ZenIV.linux.org.uk>
	<87bogx5lg7.fsf@xmission.com>
	<20120923063038.GO13973@ZenIV.linux.org.uk>
	<20120923063445.GA26640@ZenIV.linux.org.uk>
Date: Sun, 23 Sep 2012 00:00:19 -0700
In-Reply-To: <20120923063445.GA26640@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 23 Sep 2012 07:34:45 +0100")
Message-ID: <87pq5d441o.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18WRcmsVASExfmjDHrIvSF1lXopSLEdCY4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/4] devpts: Make the newinstance option historical
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sun, Sep 23, 2012 at 07:30:38AM +0100, Al Viro wrote:
>> On Sat, Sep 22, 2012 at 10:59:04PM -0700, Eric W. Biederman wrote:
>> 
>> > The test:
>> > >> +	if (filp->f_vfsmnt->mnt_root == filp->f_dentry)
>> > kicks in and no redirection is performed.
>> 
>> Umm...  OK, after the first round of recursion.  Unless you bind /something/pts
>> on /something.
>
> Other way round, of course...  E.g.
> mount --bind /dev /dev/pts
> mount --bind /dev /dev/pts/pts
> etc. enough times to overflow the kernel stack on recursion.

Except of course I gave the wrong explanation.

I did the open with O_PATH.  Since O_PATH never calls open recursion
is impossible.

Eric
