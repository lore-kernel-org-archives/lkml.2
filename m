Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1ELHwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:52:50 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61546 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1ELHwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wILzLU6oQWvzygasP9Z14+5zeMg61YzqJXPhR4OOTsLgB6F6nBDzbZj4PfNMyuEkgg
         mQrL3p+q2zJ22R9HtdjCfAggjtl1/+hvvrasmLLB2x+IW99kjJSleMOe/ovnhzYFp8nk
         8O32KXekz9uBOXZE5blMsVdyV2JMmPsg2/mU0=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1105112023560.1424@sister.anvils>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
 <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
 <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com> <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
 <BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com> <87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
 <alpine.LSU.2.00.1105112023560.1424@sister.anvils>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 12 May 2011 09:52:27 +0200
X-Google-Sender-Auth: 0XTyTlSwPIpMLQjqjoPxiI8tNYA
Message-ID: <BANLkTikAePYtmQdwapzBx9QAJLVxisy2Wg@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Dilger <adilger@dilger.ca>,
        Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 May 2011 06:20, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 19 Apr 2011, Miklos Szeredi wrote:
...
>
> I disagree with Andrew on this, it should default to off, consistent with
> the "If unsure, say N" comment.  Partly because that's how Linus prefers
> it, for good anti-bloat reasons: if people have got along without a
> feature for years, whyever should we suddenly default it on?  And
> partly because TMPFS_POSIX_ACL already defaults to off (as do
> EXT2_FS_XATTR and EXT2_FS_POSIX_ACL).
>
> However... if someone already has CONFIG_TMPFS_POSIX_ACL=y in their
> old config, it would be nice to make CONFIG_TMPFS_XATTR=y automatically,
> so we're not in danger of removing their old functionality.  But I haven't
> thought of the right way to achieve that - maybe your helpful POSIX ACL
> comment is enough, but automatic would be better.
>
> Few people would choose TMPFS_XATTR on and TMPFS_POSIX_ACL off: perhaps it
> would work to make CONFIG_TMPFS_XATTR the new config option to cover both,
> and select it from config TMPFS_POSIX_ACL (without a prompt) so the
> oldconfig propagates correctly.  Perhaps.  But I haven't tried myself,
> and you may be forgiveably disinclined to make config experiments!

The xattrs are required for overlayfs so "generic" kernels will
probably want those. However, the "generic" kernels likely have the
acls already so this is not that much of an issue.

Perhaps the acls should select xattrs so that in configs that had acls
the xattrs are added automagically.

Or does it already work with depends?

Thanks

Michal

>
>>  config TMPFS_POSIX_ACL
>>       bool "Tmpfs POSIX Access Control Lists"
>> -     depends on TMPFS
>> +     depends on TMPFS_XATTR
>>       select GENERIC_ACL
>>       help
