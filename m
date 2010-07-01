Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0GAIKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:10:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0GAIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:10:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 1 Jul 2010 10:09:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
       smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
References: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <30875.1277939713@redhat.com> <84225B35-7365-4DE2-8920-5741011B347C@dilger.ca>
In-Reply-To: <84225B35-7365-4DE2-8920-5741011B347C@dilger.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007011009.33197.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/o+iFRfxjAcq2rlieKQTXmS3cnfZNY6/9W3i9
 csySH6E5Zho7LJHIOnlCDSaPtBUNCscwubJG4e4hw1YicUGKit
 8nYvUu7lVNr4cQXOLqccA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010 06:57:07 Andreas Dilger wrote:
> If a future kernel gets a new static field at st_extra_results (say
> unsigned long long st_ino_high) with a new flag XSTAT_REQUEST_INO_HIGH
> 0x000040000ULL the kernel will think that the old app is requesting 
> this field, and will fill in the 64-bit field at st_extra_results[1]
> (which the old app didn't allocate space for, nor does it understand)
> and may get a segfault, or stack smashing, or random heap corruption.

That depends on whether the struct contains a 'buflen' field or not
(it may be part of the struct, as a syscall argument, or in a second struct).
I argue that it should not contain a buflen field and that users should
consequently not set bits that they don't know about to prevent the
scenario you describe.

If the buflen stays in, it will prevent the stack smashing part,
but add extra complexity in the interface, which can cause other
problems.

	Arnd
