Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0F1TlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:41:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44588 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0F1TlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eY50gZiGyWCHTL9w/eceEL1EqY4MoFBRX8eVLB8SjbBFzjKBiUJj+JNpi+KG9/N0yd
         l+XxVR+qBkwojrnpwtNJ12StVPgesE22FwrOBf43XJJ4Jm/9KZFW8wM+aArAHsZME0qT
         obTfXSAv/HR4TuBvckbPb2AUDjegqJTg4T41o=
MIME-Version: 1.0
In-Reply-To: <8831.1277753903@redhat.com>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
	<19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca>
	<8831.1277753903@redhat.com>
Date: Mon, 28 Jun 2010 14:41:02 -0500
Message-ID: <AANLkTikhZn15GmOTe-fsM2IgxHFxtZIRBOb_4kPWSR4E@mail.gmail.com>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation 
	available by xattrs
From: Steve French <smfrench@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, viro@zeniv.linux.org.uk,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 2:38 PM, David Howells <dhowells@redhat.com> wrote:
> Andreas Dilger <adilger@dilger.ca> wrote:
>
>> - I'd prefer calling these "file.generation" and "file.version".
>>   I don't think there is value in the "i_" prefix adds anything,
>>   and it seems more like an internal detail to me
>
> That's reasonable.
>
>> - why not expose the ".version" field for regular files?  It seems
>>   that all of them are applicable for all file types.
>
> Because Ext4 doesn't support it for anything other than directories.
>
>> - it would be good to not introduce a new xattr namespace, since
>>   tools like tar (even the RHEL-patched one) will not backup and
>>   restore these namespaces.  Using "trusted." would allow them to
>>   be backed up and restored using existing xattr-patched GNU tar
>>   by root, but wouldn't allow them to be modified by regular users.
>>   I think this is important for proper backup/restore of a filesystem,
>>   but can have correctness implications and shouldn't be accessible
>>   to regular users.
>
> Does backing them up make sense, though?  They are filesystem structural
> attributes.  Can you restore the inode number, for example?  If not, then you
> can't restore i_generation either.  Restoring i_version might make sense, but
> what if it winds i_version backwards whilst maintaining i_ino and i_generation,
> that means there'll be a time in the future where the three values are once
> again what might have been already published - and may already be in someone's
> persistent cache.

I think backing them up makes sense, even if they can't easily
be restored (ie just for reporting).

Are there security differences between the "trusted" namespace that
would make it harder for an app to read them (the man page did not list
the security differences between trusted and user xattrs).


-- 
Thanks,

Steve
