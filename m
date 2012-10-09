Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2JIEnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:43:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2JIEnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:43:51 -0400
Message-ID: <5073AB7A.3020103@suse.com>
Date: Tue, 09 Oct 2012 10:13:38 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: "smfrench@gmail.com" <smfrench@gmail.com>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "jlayton@redhat.com" <jlayton@redhat.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Convert properly UTF-8 to UTF-16
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08D16@LONPMAILBOX01.citrite.net> <20120807064752.22e0da81@corrin.poochiereds.net> <7CE799CC0E4DE04B88D5FDF226E18AC2E07634EB82@LONPMAILBOX01.citrite.net> <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408DA@LONPMAILBOX01.citrite.net> <CAH2r5msLxJVTwVrD9vs8ZOjQdRpbVyhZus4V6Su-Y8-hT229Ug@mail.gmail.com> <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408E8@LONPMAILBOX01.citrite.net>
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408E8@LONPMAILBOX01.citrite.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 01:48 PM, Frediano Ziglio wrote:
> On Wed, 2012-10-03 at 14:49 -0500, Steve French wrote:
>> Merged - but doesn't the reverse also have to be added in cifs_from_utf16?  ie
>>
>>           utf16s_to_utf8s(uni, ... );
>>
> 
> Not strictly necessary, at least to be able to mount shares.
> 
>> I am glad that someone added these multiword handling routines into
>> the kernel for FAT - this has been something we have wanted for a long
>> time in cifs (and smb2/smb3).  Note the comment in
>> fs/cifs/cifs_unicode.c
>>
>> / * Note that some windows versions actually send multiword UTF-16 characters
>>  * instead of straight UTF16-2. The linux nls routines however aren't able to
>>  * deal with those characters properly. In the event that we get some of
>>  * those characters, they won't be translated properly.
>>  */
>> int
>> cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
>>                  const struct nls_table *codepage, bool mapchar)
>>
> 
> Should not be UCS-2 instead of UTF16-2 ??
> 
>>
>> We could really use some nls test cases for cifs/smb2/smb3/nfs4 which
>> basically did various file, directory, symlink create/rename/delete
>> operations with various hard to map characters so we can test copying
>> to and from the server and ensure that we get the name mappings right
>> for these (and don't ever regress).   Fortunately smb2/smb3 is only
>> unicode so we don't have to deal with mappings to other codepages from
>> utf8
>>
> 
> Do you have some framework/hook to put these tests ?
> 

I recently wrote cifstests to primarily provide a basic infrastructure
for adding regression tests for cifs. It's written in python and the
plan to be able to use python or C bindings for python. You might
consider adding tests to it.

   https://github.com/sureshjayaram/cifstests


Thanks
Suresh
