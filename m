Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0FXOhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:37:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48212 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab0FXOhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=guM8zRBAvYRDk1VauRO+e8qebKW9RMJ3rYXS4sqdtz+fTnkSxdwPwBsZkEyo4bDSJU
         clMWMrUrBaUpF5FO5Y098DlcesUWKZoAXfKPulNVkjGmDgpUjAEZJ1js8KQmreroXxDf
         A3NjNdbJW5y/MFjGeIffryHxTtJgm8a1J9Brg=
MIME-Version: 1.0
In-Reply-To: <E1ORnGc-0008CL-Uo@pomaz-ex.szeredi.hu>
References: <20100624131455.GA10441@laptop> <4C2366F7.5010200@mit.edu> 
	<E1ORnGc-0008CL-Uo@pomaz-ex.szeredi.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 24 Jun 2010 10:37:31 -0400
X-Google-Sender-Auth: twpvqqtD8Gv9XB3SfRqrgiDgJ6U
Message-ID: <AANLkTikKTtNlWEgAL1s2uxIFDPZWn2FDYDQg96mpDsv8@mail.gmail.com>
Subject: Re: [rfc] new stat*fs-like syscall?
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       drepper@redhat.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 10:18 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, 24 Jun 2010, Andy Lutomirski wrote:
>> Something like fsid but actually specified to uniquely identify a
>> superblock.  (Currently, fsid seems to be set by the filesystem, and
>> nothing in particular ensures that two different filesystems couldn't
>> have collisions.)  We could guarantee (or have a flag guaranteeing) that
>> (fsid, st_inode) actually uniquely identifies an inode.
>>
>> Similarly, something like fsid that uniquely identifies the vfsmount
>> could be useful, although I don't know how easy that would be to provide
>> for fstat?fs.
>>
>> If we could expose the complete set of filesystem mount options so that
>> mount(1) didn't have to look at /proc/self/mounts or /etc/mtab, then
>> playing with chroots would be that much easier.
>>
>> Should we expose superblock and vfsmount options separately?  We have
>> read-only bind mounts now, but the way they work is rather inscrutable,
>> and if stat?fs could say "superblock is read-write but vfsmount is
>> readonly" then people might be able to make more sense of what's going on.
>
> You'll find all of those things in /proc/self/mountinfo.

Wasn't the point that /proc/self/mounts (and presumably
/proc/self/mountinfo) isn't scalable and we wanted a syscall to query
it efficiently (and racelessly)?

--Andy
