Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2IRJoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:44:25 -0400
Received: from mga10.intel.com ([192.55.52.92]:33483 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753829Ab2IRJoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:44:23 -0400
MIME-Version: 1.0
Date: Tue, 18 Sep 2012 12:44:21 +0300
Message-ID: <CALLzPKZqw05_4V6NQeo-A6xOza2P4g6mqxDJnv7f-ktovj_HpQ@mail.gmail.com>
Subject: IMA policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

I have asked this question already 2 times in fsdevel but have not got
any single response.

Certain file system types and partitions will never be measured or
appraised depending on the IMA policy.
For example, pseudo file systems are not measured and appraised.
In upstream IMA implementation policy will be checked again and again
for every inode in the filesystem.
It happens thousands times per second. That is absolute waste of CPU
and may be batter resources.

To overcome such issue I would like to have a flag in super block data structure
which can be set once if IMA does not need to measure anything from a partition.
The flag might be tested by ima hooks to return without doing anything.

I looked to <linux/fs.h> and found that there is a possibility to to
add additional flag for sb->s_flags.
For example

#define MS_NOT_IMA              (1<<25) /* NOT_IMA */
#define IS_I_NOT_IMA(inode)   __IS_FLG(inode, MS_NOT_IMA)


Another way is to add additional dedicated integrity related member to
the sb structure.
struct super_block {
...
#ifdef CONFIG_INTEGRITY
      int s_integrity;
#endif
};

Obviously there are only few super blocks in the system and few bytes
will not harm.

Can you please advice about this?

Thanks,
Dmitry
