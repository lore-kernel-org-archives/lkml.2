Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0GQJA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 05:00:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0GQJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 05:00:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Harris <mhlk@osj.us>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Sat, 17 Jul 2010 11:00:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
References: <201007161302.35775.arnd@arndb.de> <10677.1279283886@redhat.com> <20100717055130.GA2053@zoia.osj.us>
In-Reply-To: <20100717055130.GA2053@zoia.osj.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007171100.31186.arnd@arndb.de>
X-Provags-ID: V02:K0:m+zQl03bK8CltMuv5i6ZwkPZzZeRGnY3nxYX3M0x80x
 EzrWjXo6qkDootg8l0xMu9pZ1uDXhS6BnSibZucce+kobi5irP
 /IMA4ya6kwNiQxe/7e7jfQNTWuVj6L00PeTwbViuBY4AI+LBfP
 Bnw8cvf/1JMeThMUPkiHBpvimNODV8sFaRCfchjIFsHkslQTvc
 SpAaIBvWv2GrbbfFqJjhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 July 2010 07:51:30 Mark Harris wrote:
> David Howells wrote:
> > With a 2:2 split between exponent
> > (tv_gran_units) and mantissa (tv_granularity), you can do:
> > 
> >       UNIT            SECONDS/UNIT    EXPONENT        MANTISSA
> >       nanoseconds     0.000000001     -9              1
> >       microseconds    0.000001        -6              1
> >       millseconds     0.001           -3              1
> >       seconds         1               0               1
> >       minutes         60              1               6
> >       hours           3600            2               36
> >       days            86400           2               864
> >       weeks           604800          2               6048
> 
> At least for the in-tree filesystems, I do not see any that keep
> timestamps with a granularity larger than 2s.  For that, a simple
> 32-bit tv_granularity in nanoseconds (not limited to 1e9) would
> suffice, and there is no need for the complexity of dealing with
> a separate exponent.

Yes, good point. That would indeed be a significant simplification.

	Arnd
