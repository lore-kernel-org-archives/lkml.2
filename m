Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0F1MxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:53:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0F1MxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:53:22 -0400
Message-ID: <4C289B39.4060901@suse.de>
Date: Mon, 28 Jun 2010 18:23:13 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index
 objects and register them
References: <22746.1277470713@redhat.com> <4C24A4A0.90408@suse.de> <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com> <23204.1277472412@redhat.com>
In-Reply-To: <23204.1277472412@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 06:56 PM, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
>>>> validate the root directory of the share in some way?
>>>
>>> I don't know if there is a way to do this.
>>
>> Is there an inode number or something?  Even the creation time might do.
> 
> Looking in cifspdu.h, there are a number of things that it might be possible
> to use.
> 
>  (1) FILE_ALL_INFO: CreationTime, IndexNumber, IndexNumber1, FileName
>      (assuming this isn't flattened to '\' or something for the root of a
>      share.
> 
>  (2) FILE_UNIX_BASIC_INFO: DevMajor, DevMinor, UniqueId.
> 
>  (3) FILE_INFO_STANDARD: CreationDate, CreationTime.
> 
>  (4) FILE_INFO_BASIC: CreationTime.
> 
>  (5) FILE_DIRECTORY_INFO: FileIndex, CreationTime, FileName.
> 
>  (6) SEARCH_ID_FULL_DIR_INFO: FileIndex, CreationTime, UniqueId, FileName.
> 
>  (7) FILE_BOTH_DIRECTORY_INFO: FileIndex, CreationTime, ShortName, FileName.
> 
>  (8) OPEN_RSP_EXT: Fid, CreationTime, VolumeGUID, FileId.
> 
> You may have to choose different sets of things, depending on what the server
> has on offer.  Also, don't forget, if you can't work out whether a share is

Did you mean we need to validate differently for different servers?

I just did some testing and it looks like we could rely on CreationTime,
IndexNumber for validating with Windows servers (FileName is relative to
the mapped drive) and UniqueId for validating with Samba servers. I did
not test all possibilities (there could be more).

> coherent or not from the above, you can always use LastWriteTime, ChangeTime
> and EndOfFile and just discard the whole subtree if they differ.
> 

Thanks,

-- 
Suresh Jayaraman
