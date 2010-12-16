Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0LPWFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:05:08 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:33763 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab0LPWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VVWHQ0Jniaa78O/eVkyeFl+nHwZ1hdUm0lMBe09Q4+YDTM7FL8AV2YPK4e4W/msKXF
         catUZBg9lnAzZGRujeWt08U3oH44ghyuJl88CjisEYM2QCY8K3P0qaskUZxexT4cQW5J
         81yfRFruk+NjD8bLpbKO7ROeqWOSjM8mvjs9g=
Date: Fri, 17 Dec 2010 00:04:58 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: warn if registering world writeable files
Message-ID: <20101216220458.GA8103@core2.telecom.by>
References: <20101216203217.GA3581@p183.telecom.by>
 <20101216212609.GA9352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216212609.GA9352@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 04:26:10PM -0500, Dave Jones wrote:
> On Thu, Dec 16, 2010 at 10:32:17PM +0200, Alexey Dobriyan wrote:
>  > +	WARN_ON(S_ISREG(mode) && (mode & S_IWOTH));
>  >  	ent->mode = mode;
>  >  	ent->nlink = nlink;
>  >  	atomic_set(&ent->count, 1);
> 
> Not sure about this. For the reason I mentioned in the checkpatch diff
> that this is "usually" a problem.  There may be some use cases where
> it may actually be ok.
> 
> (I'm having a hard time thinking up a justification though tbh)

Me too.

If it's for quick debugging, one can reassign ->mode after registering and
escape the warning.
