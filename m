Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0L2JGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:06:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0L2JGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=brwqgVWQqTv28dar5VYJiO/kONNQco2lQBVXMxMBRY45W90hi+UXnDV7GBtFXCsFy7
         FbVdmyOeTBAY3KLmv1fEMJ6iFXt7sL7SmPUj4sxayuSY/KVQYsA2GWbpA96s7/vTyA+A
         A/O9lqbrp++LxUK0nq7kugOqZ2PhYDqCacApc=
Message-ID: <4D1AF923.1090502@gmail.com>
Date: Wed, 29 Dec 2010 10:02:27 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>
CC: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, tytso@mit.edu,
        chris.mason@oracle.com
Subject: Re: Bug in ext4/btrfs fallocate?
References: <4D1A0B1C.70406@gmail.com> <6A86E6B8-E14E-484B-BBF5-F3C580337661@dilger.ca>
In-Reply-To: <6A86E6B8-E14E-484B-BBF5-F3C580337661@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/12/2010 07:46, Andreas Dilger ha scritto:
> On 2010-12-28, at 09:06, Marco Stornelli wrote:
>> it seems that ext4/btrfs code for fallocate doesn't check for
>> immutable/append inode flag.
> 
> fallocate() probably shouldn't be allowed for immutable files, but it makes a lot of sense to call fallocate() on append-only files to avoid fragmentation, though it should only be called with the KEEP_SIZE flag.
> 
> Cheers, Andreas
> 

It seems that only ocfs2 does that check, however I think not checking
for immutable flag is an error, for the append case maybe you're right,
doing this operation on append-only files has got sense.

Marco
