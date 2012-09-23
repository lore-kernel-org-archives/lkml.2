Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2IWX5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 19:57:52 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59078 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2IWX5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 19:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <96965BD0-8BA7-41C0-A459-7F4DC871F607@cam.ac.uk>
References: <20120922202809.250DB3402DF@ra.kernel.org>
	<96965BD0-8BA7-41C0-A459-7F4DC871F607@cam.ac.uk>
Date: Sun, 23 Sep 2012 18:57:49 -0500
Message-ID: <CAH2r5mt+3LZkUFTb762hQyOCMs-y0cG26b9piAhyD6sMey6bOg@mail.gmail.com>
Subject: Re: cifs: fix return value in cifsConvertToUTF16
From: Steve French <smfrench@gmail.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are right - this should have gone in 3.5.

Please remind me if you see an important patch not make linux-next (or
equivalently the cifs-2.6.git for-next branch).  I get a big volume of
email.

On Sun, Sep 23, 2012 at 5:18 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> Hi Steve,
>
> Hey, I sent you that exact same patch on the 12th June!  Would have saved you and others some valuable time if you hadn't ignored it then!  (-;
>
> Told you it was an obvious logic bug!  (-;
>
> Best regards,
>
>         Anton
>
> On 22 Sep 2012, at 21:28, Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>
>> Gitweb:     http://git.kernel.org/linus/;a=commit;h=c73f693989d7a7d99ec66a7065295a0c93d0b127
>> Commit:     c73f693989d7a7d99ec66a7065295a0c93d0b127
>> Parent:     4651afbbae968772efd6dc4ba461cba9b49bb9d8
>> Author:     Jeff Layton <jlayton@redhat.com>
>> AuthorDate: Tue Sep 18 14:21:01 2012 -0400
>> Committer:  Steve French <smfrench@gmail.com>
>> CommitDate: Tue Sep 18 15:35:25 2012 -0500
>>
>>    cifs: fix return value in cifsConvertToUTF16
>>
>>    This function returns the wrong value, which causes the callers to get
>>    the length of the resulting pathname wrong when it contains non-ASCII
>>    characters.
>>
>>    This seems to fix https://bugzilla.samba.org/show_bug.cgi?id=6767
>>
>>    Cc: <stable@vger.kernel.org>
>>    Reported-by: Baldvin Kovacs <baldvin.kovacs@gmail.com>
>>    Reported-and-Tested-by: Nicolas Lefebvre <nico.lefebvre@gmail.com>
>>    Signed-off-by: Jeff Layton <jlayton@redhat.com>
>>    Signed-off-by: Steve French <smfrench@gmail.com>
>> ---
>> fs/cifs/cifs_unicode.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> index 7dab9c0..53cf2aa 100644
>> --- a/fs/cifs/cifs_unicode.c
>> +++ b/fs/cifs/cifs_unicode.c
>> @@ -328,7 +328,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>>       }
>>
>> ctoUTF16_out:
>> -     return i;
>> +     return j;
>> }
>>
>> #ifdef CONFIG_CIFS_SMB2
>
> --
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
>



-- 
Thanks,

Steve
