Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab0JFGS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:18:27 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58276 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab0JFGS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:18:26 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 1/3] fs/9p: Update TLCREATE to allow create without open
In-Reply-To: <AANLkTinpie0YLpiuJjv1RzYr4LN1HbdtXh=OoNNJbG6k@mail.gmail.com>
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <AANLkTinpie0YLpiuJjv1RzYr4LN1HbdtXh=OoNNJbG6k@mail.gmail.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.2 (i686-pc-linux-gnu)
Date: Wed, 06 Oct 2010 11:48:15 +0530
Message-ID: <m362xfkfo8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 13:15:42 -0400, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> Ouch.  Protocol change.
> 
> Also - not sure I understand what's going on here.  Why does mknod go
> through TLCREATE, shouldn't we have our
> own protocol messages for mknod?//

This is needed for the below mknod usage

mknod("k2", S_IFREG) ;


> 
> Why add an additional flag field instead of just using the existing
> flags field since we are only talking about a bit?
> 

TLCREATE is 

  size[4] Tlcreate tag[2] fid[4] name[s] flags[4] mode[4] gid[4]
    
  size[4] Rlcreate tag[2] qid[13] iounit[4]
    

The flags argument represent Linux access mode flags with which the caller
is requesting to open the file with. Protocol allows all the Linux
access

Having a -1 with the flag would indicate all the access mode flags are
set. So i found that to be ugly. And value 0 indicate O_RDONLY. So was
not sure whether -1 in flags or having a separate lookup flags is the
right thing to do.

-aneesh
