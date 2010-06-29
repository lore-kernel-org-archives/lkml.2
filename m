Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0F2W7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:59:48 -0400
Received: from fn.samba.org ([216.83.154.106]:42888 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab0F2W7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:59:46 -0400
Date: Tue, 29 Jun 2010 15:59:44 -0700
From: Jeremy Allison <jra@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
       viro@zeniv.linux.org.uk, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and
	i_generation available by xattrs
Message-ID: <20100629225944.GA22924@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20100628164854.GA9979@samba1> <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com> <26197.1277851477@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26197.1277851477@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:44:37PM +0100, David Howells wrote:
> Jeremy Allison <jra@samba.org> wrote:
> 
> > We already have code in Samba to detect "birthtime"
> > (st_btime) as a returned member of a stat struct.
> 
> Is it, though?
> 
> Googling for st_btime suggests it could also be taken as the time last
> archived.  That may just be a NetWareism though.

It's a *BSD'ism.

http://www.daemon-systems.org/man/fstat.2.html

     #if defined(_NETBSD_SOURCE)
         struct timespec st_birthtimespec;   /* time of inode creation */
     #else
         time_t    st_birthtime;             /* time of inode creation */
         long      st_birthtimensec;         /* nsec of inode creation */
     #endif

http://www.unix.com/man-page/FreeBSD/2/stat/

st_birthtime  Time when the inode was created.

Of course, for Samba's use we also have to be
able to *write* to st_birthtime as Windows clients
can change this. But that's what the EA is for
(and I'm happy with a system that can only read
st_birthtime, not write it).

Jeremy.
