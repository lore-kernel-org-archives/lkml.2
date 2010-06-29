Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0F2WeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:34:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64115 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab0F2Wd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lORVQsrf5TysorkerQN41uOT2Lc1xR1fYBFv9/8OlBts0abofvpW8CwE0E1YqD7jHH
         5vQtm+mLbvEZxcmmDkdcrgS9NY7BUNcuwC5npIuMP6xkq/++CjsDkrw80OAzuNv5WVVo
         zjpzFuWacUnib5mryMGfo1jL5qPU/Nh4G7lI4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
	<20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
	<AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
Date: Tue, 29 Jun 2010 17:33:56 -0500
Message-ID: <AANLkTimieV9ybz2XrD29tvz1mogdMA5VHH4lNSwPovoE@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file 
	stats available
From: Steve French <smfrench@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 5:13 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Tue, Jun 29, 2010 at 13:03, David Howells <dhowells@redhat.com> wrote:
>> Add a pair of system calls to make extended file stats available, including
>> file creation time, inode version and data version where available through the
>> underlying filesystem:
>
> If you add something like this you might want to integrate another
> extension.  This has been discussed a long time ago.  In almost no
> situation all the information is needed.  Some of the pieces of
> information returned by the syscall might be harder to collect than
> other.  It makes sense in such a situation to allow the caller to
> specify what she is interested in.  A bitmask of some sort.  This was
> brought up by the HPC people with gigantic filesystems.
>
> For this the syscall interface should have a parameter to specify what
> is requested and the stat-like structure should have a field
> specifying what is actually present.  The latter bitmask must be a
> superset of the former.
>
> Previous discussions centered around reusing the stat data structure
> and somehow make it work.  But no clean solution was found.  If a new
> structure is added anyway this could solve the issue.

That makes sense, especially for network file systems.  NFSv4
protocol spec anticipates that:

"With the NFS version 4 protocol, the client is able query what attributes
   the server supports and construct requests with only those supported
   attributes (or a subset thereof)."

and we were talking about something similar for SMB2 Unix Extensions
(posix extensions) at the last plugfest (for SMB2 kernel
client to Samba)
and testing events.
-- 
Thanks,

Steve
