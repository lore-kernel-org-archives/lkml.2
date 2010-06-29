Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0F2WN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:13:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57755 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0F2WNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GtHFgqjhT6Ma2t8KgGhaGnXa76kAptUvwokfDzWqv7YP1DAQBeLDkhB6eJYW0irftn
         77DcatyJGTvUT3oFuZb171K+umphynZJix/iZIyKj+3NTFeNbeL46Dpd7IZehhMWYrMl
         OWHdT3s+Tc0PovjSDhNGihlb3WF8B0S56k8yw=
MIME-Version: 1.0
In-Reply-To: <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> 
	<20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 29 Jun 2010 15:13:04 -0700
Message-ID: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file 
	stats available
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 13:03, David Howells <dhowells@redhat.com> wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem:

If you add something like this you might want to integrate another
extension.  This has been discussed a long time ago.  In almost no
situation all the information is needed.  Some of the pieces of
information returned by the syscall might be harder to collect than
other.  It makes sense in such a situation to allow the caller to
specify what she is interested in.  A bitmask of some sort.  This was
brought up by the HPC people with gigantic filesystems.

For this the syscall interface should have a parameter to specify what
is requested and the stat-like structure should have a field
specifying what is actually present.  The latter bitmask must be a
superset of the former.

Previous discussions centered around reusing the stat data structure
and somehow make it work.  But no clean solution was found.  If a new
structure is added anyway this could solve the issue.


And while you're at it, maybe some spare fields at the end are nice.
