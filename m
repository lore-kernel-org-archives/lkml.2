Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965468Ab1JGNj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:39:56 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:46832 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965418Ab1JGNjz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:39:55 -0400
X-AuditID: 12074425-b7f116d0000008fe-a1-4e8f012a7e40
Subject: =?windows-1252?Q?Re=3A_A_Plumber=92s_Wish_List_for_Linux?=
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
Date: Fri, 7 Oct 2011 09:39:49 -0400
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Content-Transfer-Encoding: 8BIT
Message-Id: <8E8162FF-C301-40C1-9FBC-9B6ADB29BC59@mit.edu>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk> <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com> <20111007113820.3b8424a8@lxorguk.ukuu.org.uk> <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Apple Mail (2.1244.3)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsUixG6noqvF2O9ncG61jMXq9UdYLKbd2sFs
	cW7BDEaL55+2s1pc3nCOzeJb3zNGi8u75rA5sHv0vTvK5vH2YYBH68lNrB5X1r9n9Hi/7yqb
	x+dNch4f13sGsEdx2aSk5mSWpRbp2yVwZSyfsIy5oJ27YsHSTuYGxhscXYycHBICJhI9nfuY
	IGwxiQv31rN1MXJxCAnsY5R43XyUDSQhJLCeUeL89TQIeymTRMNvaRBbWMBZ4veDS4xdjBwc
	vALGEq//gc1hFtCSuPHvJZjNJqAkcefTfhYQm1MgUOJUfzMriM0ioCLxumEfI8guZoFFjBK/
	ty1lhmjWlli28DWYzStgJTHjy31miIMmMEk0X7sBNlVEQE1iwf71UFfLSyxu+cw4gVFwFsId
	s5DcMQvJ2AWMzKsYZVNyq3RzEzNzilOTdYuTE/PyUot0LfRyM0v0UlNKNzGCo8NFdQfjhENK
	hxgFOBiVeHhnPe31E2JNLCuuzD3EKMnBpCTKe/JPn58QX1J+SmVGYnFGfFFpTmrxIUYJDmYl
	EV6HN0A53pTEyqrUonyYlDQHi5I47+sdDn5CAumJJanZqakFqUUwWRkODiUJ3m6Gfj8hwaLU
	9NSKtMycEoQ0EwcnyHAeoOE/QWp4iwsSc4sz0yHypxgVpcR5Z4AkBEASGaV5cL2w5PWKURzo
	FWHeDpAqHmDig+t+BTSYCWgw//UekMEliQgpqQZGr3gBY/nT7+Z+FnjfMl2lzcJwWYffPZ7o
	NIXT177+6GjsE23Y//qYnNTyFQ8d4/KrVSfFhby9nsHVfvD3p2dTzvrJmDndFJhsHB8ZW7Vt
	9oltAX/MIqKV7wjoqc/zenJjiuxNRZdHIVEavhcuVzxteuLR9OvU0WsrkvS3FNWIFkRapO3S
	T3+lxFKckWioxVxUnAgAXH8aeTkDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2011, at 8:46 AM, Kay Sievers wrote:
> On Fri, Oct 7, 2011 at 12:38, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Fri, 7 Oct 2011 12:28:46 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> What do you mean would be ugly?
>> 
>> I have an ext4fs. It supports every possible file name allowed by POSIX
>> and SuS. What name are you going to use for your 'hidden directory' that
>> won't clash with a real file ?
> 
> Ah, no. The label on FAT (similar on NTFS) are 'magic entries' in the
> root dir list, not a real file in the root dir.
> 
> We need kernel support for changing a mounted fs, because, unlike
> ext4, the blocks containing the strings are inside the fs, which the
> kernel might change any time.

I'd suggest a syscall, not an ioctl, and if a file system has some limitation on what is a valid name (even ext4 has length limitations which might be different from other file systems), we just simply return an error if it's not a valid label name.

As it turns out I went to great lengths in both the kernel and userspace implementations of e2label/tune2fs to make sure it would be safe to directly edit the superblock while the file system is mounted, but that depends on implementation details of the buffer cache in the kernel.  Better to have a formally supported interface which is file system independent.

-- Ted


