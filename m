Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0HQPtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:49:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:45668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab0HQPtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:49:13 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>, viro@zeniv.linux.org.uk
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 17 Aug 2010 17:48:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008171038.50456.agruen@suse.de> <1282058668.21419.131.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282058668.21419.131.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171748.57319.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 17:24:28 Eric Paris wrote:
> On Tue, 2010-08-17 at 10:38 +0200, Andreas Gruenbacher wrote:
> > One of the wonky remaining bits is the way how files are reopened with
> > dentry_open() with the f_flags passed to fanotify_init().  The open can
> > fail, in which case the user is left with an error condition but with no
> > indication as to which object the error happened for.  What the heck?
> 
> What else can be done?  When notification is based on an open fd and you
> can't give them an open fd, there's nothing left....

The main point would be to allow the listener to object the event is about.  
This could be done by returning st_dev and st_ino in the event. (i_generation 
might be useful too but we don't even return that in struct stat today.)

Another way would be to return a file pointer to a bad inode that can be 
stat() normally, and to return the error code separately.

Al might have an opinion on that.

Andreas
