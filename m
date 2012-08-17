Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2HQU6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:58:53 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34781 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2HQU6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:58:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Helsley <matt.helsley@gmail.com>
References: <20120815210237.GF25421@moon>
	<20120815220622.GA28054@fieldses.org> <20120816062448.GA32081@moon>
	<20120816123814.GD1209@moon>
	<20120816134339.GQ23464@ZenIV.linux.org.uk>
	<502CF9DA.8030701@parallels.com>
	<20120816135019.GS23464@ZenIV.linux.org.uk>
	<20120816135448.GP32081@moon>
	<1345125779.3259.50.camel@dabdike.int.hansenpartnership.com>
	<20120816141553.GF1209@moon>
	<20120816144152.GT23464@ZenIV.linux.org.uk>
Date: Fri, 17 Aug 2012 13:58:31 -0700
In-Reply-To: <20120816144152.GT23464@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 16 Aug 2012 15:41:52 +0100")
Message-ID: <87r4r5z154.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Qgt1reuJo9HKyHrpI/33VBp/AMrC6mf8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, Aug 16, 2012 at 06:15:53PM +0400, Cyrill Gorcunov wrote:
>> On Thu, Aug 16, 2012 at 02:03:00PM +0000, James Bottomley wrote:
>> > > > What's wrong with saying "we don't support idiotify"?
>> > > 
>> > > Al, we need some way to restore inotifies after checkpoint.
>> > > At the very early versions of these patches I simply added
>> > > dentry to the inotify mark thus once inotify created we always
>> > > have a dentry to refer on in encode_fh, but I'm not sure if
>> > > this will be good design.
>> > 
>> > Actually, I was about to suggest this.  This can be done internally
>> > within fs/notify without actually modifying the syscall interface, can't
>> > it, since they take a path which is used to obtain the inode?  It looks
>> > like the whole of the inotify interface could be internally recast to
>> > use dentries instead of inodes.  Unless I've missed something obvious?
>> 
>> Well, after looking into do_sys_name_to_handle->exportfs_encode_fh
>> sequence more precisely it seems it will be easier to extend
>> exportfs_encode_fh to support inodes directly instead of playing
>> with notify code (again, if i'm not missing something too).
>> i'm cooking a patch to show (once it's tested i'll send it out).
>
> Good luck doing that with e.g. VFAT...  And then there's such thing
> as filesystems that don't have ->encode_fh() for a lot of very good
> reasons; just try to do that on sysfs, for example.  Or on ramfs,
> for that matter...  And while saying "you can't export that over
> NFS" seems to work fine, idiotify-lovers will screech if you try
> to ban their perversion of choice on those filesystems.

For whatever it is worth inotify does not currently work on sysfs or
procfs or any other filesystem that looks like a network filesystem and
whose modifications don't proceed through the vfs like a normal
filesystem.

Eric
