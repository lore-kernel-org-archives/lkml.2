Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1KCXZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:25:18 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45209 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1KCXZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:25:17 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20111103134056.178ee9e3@barsoom.rdu.redhat.com>
Date: Thu, 3 Nov 2011 23:25:12 +0000
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <A2505FE2-FE28-4C23-879E-357C9D3AA03F@cam.ac.uk>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk> <81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk> <20111103134056.178ee9e3@barsoom.rdu.redhat.com>
To: Jeff Layton <jlayton@redhat.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 3 Nov 2011, at 17:40, Jeff Layton wrote:
> On Thu, 3 Nov 2011 15:42:13 +0000 Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>> 
>> I should add that we are using iocharset=utf8 mount option which means that the dcache hash/compare functions done in the cifs module do not work because it uses nls_tolower() and nls_strnicmp() both of which for utf8 NLS in the kernel do not do anything at all and effectively behave case sensitively!
>> 
>> Thus this bug/problem in all likelyhood only affects utf8 iocharset users on a case-insensitive but case-preserving CIFS server that does not support server inode numbers.
>> 
>> That probably explains why it has not been noticed before!
>> 
>> We need utf8 thus we still need to fix this issue.

> I'm confused...
> 
> If the filesystem being served out by the server is using utf8, then
> how is it handling the case-insensitivity?


The file system being served is NSS (the Netware one but now mounted on Open Enterprise Server with Linux kernel rather than actual Netware kernel).  No idea how it works I am afraid.  It supports lots of different namespaces as well as being case-insensitive and case preserving when using the LONG name space (which is now being served through CIFS).

If it was NTFS or exFAT I could tell you exactly how they work (each volume has an upcase table mapping the 65536 UCS-2 Unicode characters to their upper case equivalents and each 16-bit character is upper-cased individually, more recently Windows has switched to using UTF-16 instead of UCS-2 and the upcase table changed when that happened though it remained the same size and I think for file system purposes the fact that there are surrogates in the above UCS-2   Unicode range is simply ignored)...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

