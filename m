Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1DUHAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:00:17 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62095 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1DUHAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=icfYUz7ui9xR83AqwLV8wGsrosGkLODkC6r7KrCBTb9RDaBiGpqATNk1S1Fo/zqy8p
         KQWjKYZ27ooP/OZ0vRAgl+vyHMY5VuKDJBITcyDC1YTIK44fHbllOTCvkLShIgd5xOt7
         foQVYWq4dtpTt8Uy02xXy+hW9y3qdTgn/SUeU=
MIME-Version: 1.0
In-Reply-To: <87tydtm41s.fsf@tucsk.pomaz.szeredi.hu>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
 <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
 <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com> <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
 <BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com> <87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
 <BANLkTinXVDrLnMOo17pqua5+38yQsezG6g@mail.gmail.com> <87tydtm41s.fsf@tucsk.pomaz.szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 21 Apr 2011 08:59:54 +0200
X-Google-Sender-Auth: LcYIRXI8kbqD9LbMoxiscOIq5wc
Message-ID: <BANLkTikJ_7ZZ+1uC=0RBmKmxqFhVyLiYsw@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Phillip Lougher <phillip.lougher@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 April 2011 15:43, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Phillip Lougher <phillip.lougher@gmail.com> writes:
>
>> On Tue, Apr 19, 2011 at 9:04 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>> +static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
>>
>>> +       spin_lock(&dentry->d_inode->i_lock);
>>> +       list_for_each_entry(xattr, &info->xattr_list, list) {
>>> +               /* skip "trusted." attributes for unprivileged callers */
>>> +               if (!trusted && xattr_is_trusted(xattr->name))
>>> +                       continue;
>>> +
>>> +               used += strlen(xattr->name) + 1;
>>> +               if (buffer) {
>>> +                       if (size < used) {
>>> +                               used = -ERANGE;
>>> +                               break;
>>> +                       }
>>> +                       strncpy(buffer, xattr->name, strlen(xattr->name) + 1);
>>>+                        buffer += strlen(xattr->name) + 1;
>>
>> Why are you doing a strncpy here?  strcpy() isn't going to copy more
>> than strlen(xattr->name) + 1 bytes, and you know buffer is large
>> enough to hold that because of the previous if (size < used) check?
>>
>> If you assigned the first strlen(xattr->name) + 1 to a temporary
>> variable, you could use memcpy here, and avoid the 3 repeated
>> strlen(xattr->name) calls.
>
> Yeah, makes sense.
>

Can you put up a branch with both overlayfs and xattrs?

I would like to point people at a repo with working implementation and
mirroring the kernel tree to add one patch is a bit overkill.

Thanks

Michal
