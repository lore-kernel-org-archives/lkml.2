Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1L2Nju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 08:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1L2Njt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 08:39:49 -0500
Date: Thu, 29 Dec 2011 08:39:30 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Message-ID: <20111229083930.77fafba8@tlielax.poochiereds.net>
In-Reply-To: <4EFC413A.80302@gmail.com>
References: <4EFBAF99.3010208@gmail.com>
	<20111228210420.2a422d11@corrin.poochiereds.net>
	<4EFC413A.80302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Dec 2011 12:30:18 +0200
Konstantinos Skarlatos <k.skarlatos@gmail.com> wrote:

> On 29/12/2011 4:04 πμ, Jeff Layton wrote:
> > On Thu, 29 Dec 2011 02:08:57 +0200
> > Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
> >
> >> I mount via cifs a windows XP share, df gives me correct sizes, but when
> >> I ls the mount point i get input/output error.
> >> strace: http://pastebin.com/WXf8M1nu
> >>
> >> mount --verbose -t cifs -o username=administrator,password=blahblah
> >> //192.168.0.11/jobs /mnt/backups/montaz/jobs
> >> mount.cifs kernel mount options:
> >> ip=192.168.0.11,unc=\\192.168.0.11\jobs,,ver=1,user=administrator,pass=********
> >>
> >> df
> >> //192.168.0.11/jobs                                       114464
> >> 105196      9268  92% /mnt/backups/montaz/jobs
> >>
> >> ls /mnt/backups/montaz/jobs/
> >> ls: reading directory /mnt/backups/montaz/jobs/: Input/output error
> >> total 0
> >>
> >> the fun thing is that i can cd to a lower level directory, and ls works
> >> fine there! only the mount point has the problem
> >>
> >> ls /mnt/backups/montaz/jobs/test
> >> total 44K
> >> drwxr-xr-x 1 root root    0 Apr 30  2010 blah blah/
> >> ......
> >>
> >> kernel version 3.2rc7
> >>
> >> this seems to be related to :
> >> https://lkml.org/lkml/2011/8/1/427
> >> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs
> >>
> > Hmmm, maybe. What makes you think that it's related? What sort of
> > server are you seeing this against?
> Windows XP service pack 2 (greek)


How many files are in the directory?

-- 
Jeff Layton <jlayton@redhat.com>
