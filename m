Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0LPV0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:26:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab0LPV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:26:36 -0500
Date: Thu, 16 Dec 2010 16:26:10 -0500
From: Dave Jones <davej@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: warn if registering world writeable files
Message-ID: <20101216212609.GA9352@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20101216203217.GA3581@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216203217.GA3581@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:32:17PM +0200, Alexey Dobriyan wrote:
 > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
 > ---
 > 
 >  fs/proc/generic.c |    1 +
 >  1 file changed, 1 insertion(+)
 > 
 > --- a/fs/proc/generic.c
 > +++ b/fs/proc/generic.c
 > @@ -623,6 +623,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 >  	memcpy(((char *) ent) + sizeof(struct proc_dir_entry), fn, len + 1);
 >  	ent->name = ((char *) ent) + sizeof(*ent);
 >  	ent->namelen = len;
 > +	WARN_ON(S_ISREG(mode) && (mode & S_IWOTH));
 >  	ent->mode = mode;
 >  	ent->nlink = nlink;
 >  	atomic_set(&ent->count, 1);

Not sure about this. For the reason I mentioned in the checkpatch diff
that this is "usually" a problem.  There may be some use cases where
it may actually be ok.

(I'm having a hard time thinking up a justification though tbh)

	Dave

