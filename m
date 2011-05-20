Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab1ETLMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:12:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203Ab1ETLME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vcsWgoBpDtjvjBKSzAKRBbt9bTvUlGjfJMwcomaOEkRT2dvetvMLD96gi06bIOlcLl
         okgVNsjrtOswHjzGg5Vi/Kdtao61WwoecTd9eU7uleiMojW5vqQQ17j2YeIP4U9tIRBc
         lLLvPtvKVePJ4YhCIFifV1S2L7bwDRofMdFPE=
Message-ID: <4DD64CA7.7090307@gmail.com>
Date: Fri, 20 May 2011 13:12:39 +0200
From: Harald Hoyer <harald.hoyer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v5 03/21] evm: re-release
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>	 <1305557115-15652-4-git-send-email-zohar@linux.vnet.ibm.com>	 <20110519060543.GA10320@mail.hallyn.com> <1305845343.2528.3.camel@localhost.localdomain>
In-Reply-To: <1305845343.2528.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.05.2011 00:49, schrieb Mimi Zohar:
> On Thu, 2011-05-19 at 01:05 -0500, Serge E. Hallyn wrote: 
>> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
>>> EVM protects a file's security extended attributes(xattrs) against integrity
>>> attacks.  This patchset provides the framework and an initial method.  The
>>> initial method maintains an HMAC-sha1 value across the security extended
>>> attributes, storing the HMAC value as the extended attribute 'security.evm'.
>>> Other methods of validating the integrity of a file's metadata will be posted
>>> separately (eg. EVM-digital-signatures).
>>>
>>> While this patchset does authenticate the security xattrs, and
>>> cryptographically binds them to the inode, coming extensions will bind other
>>> directory and inode metadata for more complete protection.  To help simplify
>>> the review and upstreaming process, each extension will be posted separately
>>> (eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
>>> proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
>>> http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.
>>>
>>> EVM depends on the Kernel Key Retention System to provide it with a
>>> trusted/encrypted key for the HMAC-sha1 operation. The key is loaded onto the
>>> root's keyring using keyctl.  Until EVM receives notification that the key has
>>> been successfully loaded onto the keyring (echo 1 > <securityfs>/evm), EVM can
>>> not create or validate the 'security.evm' xattr, but returns INTEGRITY_UNKNOWN.
>>> Loading the key and signaling EVM should be done as early as possible. Normally
>>> this is done in the initramfs, which has already been measured as part of the
>>> trusted boot.  For more information on creating and loading existing
>>> trusted/encrypted keys, refer to Documentation/keys-trusted-encrypted.txt.  A
>>> sample dracut patch, which loads the trusted/encrypted key and enables EVM, is
>>> available from http://linu-ima.sourceforge.net/#EVM.
>>
>> That should read http://linux-ima.sourceforge.net/#EVM.
> 
> Thanks for catching that.

The dracut patch, could easily turned into a separate dracut module with its own
files, without patching. Somebody did not understand the modular nature of
dracut. While you are at it, I happily integrate that module in upstream, if you
submit it to the initramfs mailing list.
