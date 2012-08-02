Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2HBNBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:01:42 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56700 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2HBNBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:01:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ludwig Nussel <ludwig.nussel@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz> (maintainer:EXT2 FILE SYSTEM),
        Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
        Andrew Morton <akpm@linux-foundation.org> (maintainer:EXT3 FILE
	SYSTEM),
        Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT3 FILE
	SYSTEM),
        "Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM),
        linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
References: <1343908443-17369-1-git-send-email-ludwig.nussel@suse.de>
	<1343908443-17369-2-git-send-email-ludwig.nussel@suse.de>
	<20120802130642.46b12c59@pyramind.ukuu.org.uk>
Date: Thu, 02 Aug 2012 06:00:55 -0700
In-Reply-To: <20120802130642.46b12c59@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Thu, 2 Aug 2012 13:06:42 +0100")
Message-ID: <87629130u0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18GVDh9oSK7RNI1v3saMKTI/Ts272fkBQI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1244]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] implement uid and gid mount options for ext2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> +uid=n[:m]			Make all files appear to belong to uid n.
>> +				Useful for e.g. removable media with fstab
>> +				options 'user,uid=useruid'. The optional second
>> +				uid m is actually written to the file system.
>
> So what happens if I insert a USB key containing a device node to the
> hard disk ? Why is this functionality useful in the current form ?
>
> (ie I think you need an actual rational security model first)

> Also why is this at the per fs level duplicating stuff each time rather
> than at the vfs level - this seems to be vfs level functionality.

Even more fun there is essentially a generic implementation in the user
namespaces.  What needs to be implemented to support this is support for
mounting in a non-default user namespace, and then all of the mapping
functionality is generic.  Which I presume will imply MS_NODEV.

Eric
