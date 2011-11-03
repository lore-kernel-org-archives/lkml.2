Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1KCXeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:34:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42932 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KCXeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <A2505FE2-FE28-4C23-879E-357C9D3AA03F@cam.ac.uk>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
	<81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
	<20111103134056.178ee9e3@barsoom.rdu.redhat.com>
	<A2505FE2-FE28-4C23-879E-357C9D3AA03F@cam.ac.uk>
Date: Thu, 3 Nov 2011 18:34:00 -0500
Message-ID: <CAH2r5mtye1DHKbPYMKnkcZjfVKBqek=a7DWGPJvxCsoLEhzDXA@mail.gmail.com>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
From: Steve French <smfrench@gmail.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the actual sequence of events from the wire perspective (the
actual smb requests sent)?


On Thu, Nov 3, 2011 at 6:25 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> Hi,
>
> On 3 Nov 2011, at 17:40, Jeff Layton wrote:
>> On Thu, 3 Nov 2011 15:42:13 +0000 Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>>>
>>> I should add that we are using iocharset=utf8 mount option which means that the dcache hash/compare functions done in the cifs module do not work because it uses nls_tolower() and nls_strnicmp() both of which for utf8 NLS in the kernel do not do anything at all and effectively behave case sensitively!
>>>
>>> Thus this bug/problem in all likelyhood only affects utf8 iocharset users on a case-insensitive but case-preserving CIFS server that does not support server inode numbers.
>>>
>>> That probably explains why it has not been noticed before!
>>>
>>> We need utf8 thus we still need to fix this issue.
>
>> I'm confused...
>>
>> If the filesystem being served out by the server is using utf8, then
>> how is it handling the case-insensitivity?
>
>
> The file system being served is NSS (the Netware one but now mounted on Open Enterprise Server with Linux kernel rather than actual Netware kernel).  No idea how it works I am afraid.  It supports lots of different namespaces as well as being case-insensitive and case preserving when using the LONG name space (which is now being served through CIFS).
>
> If it was NTFS or exFAT I could tell you exactly how they work (each volume has an upcase table mapping the 65536 UCS-2 Unicode characters to their upper case equivalents and each 16-bit character is upper-cased individually, more recently Windows has switched to using UTF-16 instead of UCS-2 and the upcase table changed when that happened though it remained the same size and I think for file system purposes the fact that there are surrogates in the above UCS-2   Unicode range is simply ignored)...
>
> Best regards,
>
>        Anton
> --
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
>
>



-- 
Thanks,

Steve
