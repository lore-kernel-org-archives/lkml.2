Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0DUWZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:25:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34708 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0DUWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:25:30 -0400
Message-ID: <4BCF7ADB.6080409@oracle.com>
Date: Wed, 21 Apr 2010 15:23:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/14] EVM
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>	 <20100421145848.b36ab7bd.randy.dunlap@oracle.com> <1271888338.2650.13.camel@localhost.localdomain>
In-Reply-To: <1271888338.2650.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BCF7B58.0061:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/10 15:18, Mimi Zohar wrote:
> On Wed, 2010-04-21 at 14:58 -0700, Randy Dunlap wrote:
>> On Wed, 21 Apr 2010 17:49:40 -0400 Mimi Zohar wrote:
>>
>>> Extended Verification Module(EVM) detects offline tampering of the
>>> security extended attributes (e.g. security.selinux, security.SMACK64,
>>> security.ima), which is the basis for LSM permission decisions and,
>>> with this set of patches, integrity appraisal decisions. To detect
>>> offline tampering of the extended attributes, EVM maintains an
>>> HMAC-sha1 across a set of security extended attributes, storing the
>>> HMAC as the extended attribute 'security.evm'. To verify the integrity
>>> of an extended attribute, EVM exports evm_verifyxattr(), which
>>> re-calculates the HMAC and compares it with the version stored in
>>> 'security.evm'.
>>>
>> ...
>>>
>>> Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
>>> reviewing the patches.
>>>
>>> Mimi
>>>
>>> Mimi Zohar (14):
>>>   integrity: move ima inode integrity data management
>>>   security: move LSM xattrnames to xattr.h
>>>   xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
>>>   evm: re-release
>>>   ima: move ima_file_free before releasing the file
>>>   security: imbed evm calls in security hooks
>>>   evm: inode post removexattr
>>>   evm: imbed evm_inode_post_setattr
>>>   evm: inode_post_init
>>>   fs: add evm_inode_post_init calls
>>>   ima: integrity appraisal extension
>>>   ima: appraise default rules
>>>   ima: inode post_setattr
>>>   ima: add ima_inode_setxattr and ima_inode_removexattr
>>> --
>>
>> A summary diffstat would be good to see in patch 00/14.
>>
>> Lacking that, at least each individual patch should have a diffstat summary
>> in it.  Please read Documentation/SubmittingPatches.
>>
>> ---
>> ~Randy
> 
> Only two minor changes from the RFC posting:
> 
> 0011-ima-integrity-appraisal-extension.patch adds a missing
> ima_fix_xattr() call.


diffstat summary example, from a series of 35 filesystem patches:

 Documentation/filesystems/union-mounts.txt |  708 ++++++++++++++++++++++
 Documentation/filesystems/vfs.txt          |   16 +-
 fs/Kconfig                                 |   13 +
 fs/Makefile                                |    1 +
 fs/autofs4/autofs_i.h                      |    1 +
 fs/autofs4/init.c                          |   11 +-
 fs/autofs4/root.c                          |    6 +
 fs/compat.c                                |    9 +
 fs/dcache.c                                |   35 +-
 fs/ext2/dir.c                              |  248 +++++++-
 fs/ext2/ext2.h                             |    4 +
 fs/ext2/inode.c                            |   11 +-
 fs/ext2/namei.c                            |   89 +++-
 fs/ext2/super.c                            |    6 +
 fs/jffs2/dir.c                             |  104 ++++-
 fs/jffs2/fs.c                              |    4 +
 fs/jffs2/super.c                           |    2 +-
 fs/libfs.c                                 |   21 +-
 fs/namei.c                                 |  793 ++++++++++++++++++++++---
 fs/namespace.c                             |  146 +++++-
 fs/nfsd/nfs3xdr.c                          |    5 +
 fs/nfsd/nfs4xdr.c                          |    5 +
 fs/nfsd/nfsxdr.c                           |    4 +
 fs/open.c                                  |  116 +++-
 fs/readdir.c                               |   18 +
 fs/super.c                                 |   23 +
 fs/union.c                                 |  881 ++++++++++++++++++++++++++++
 fs/utimes.c                                |   13 +-
 include/linux/dcache.h                     |   40 ++
 include/linux/ext2_fs.h                    |    5 +
 include/linux/fs.h                         |   16 +
 include/linux/jffs2.h                      |    8 +
 include/linux/mount.h                      |    7 +-
 include/linux/namei.h                      |    2 +
 include/linux/union.h                      |   77 +++
 mm/shmem.c                                 |  195 ++++++-
 36 files changed, 3483 insertions(+), 160 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 include/linux/union.h


This summarizes which files are changed and how much, so that interested
people can know if they want to review the patches.

-- 
~Randy
