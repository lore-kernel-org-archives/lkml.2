Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0LURf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:35:58 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:44261 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LURf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:35:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vokfsmeu7niKXuJtjUNin4ZUuxz8kIZsb4vUeCJu4S+/CQpsOIqDNpDraY5KRqO4y8
         0NEiledFC5ELDGjIOlcEYAvgt42f7MaHc6sa1SwDNy9RQldFBpfvTfHopgMf+vdD8UQo
         EfPoF0ooPMrfqKjRbsHPFs2nYzdy1NlOD6LdI=
Date: Tue, 21 Dec 2010 18:35:52 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 11/16] signal: prepare for CLD_* notification changes
Message-ID: <20101221173550.GG13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-12-git-send-email-tj@kernel.org>
 <20101220162120.GA15755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220162120.GA15755@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:21:20PM +0100, Oleg Nesterov wrote:
> > @@ -1640,6 +1684,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
> >   	}
> >
> >  	sighand = parent->sighand;
> > +	sig = parent->signal;
> 
> This looks unneeded.

Yeah, it's unneeded but sighand and sig are used earlier in the
function to point to the respective structures of the child while in
the latter part for the parent.  I was afraid a later change to the
parent part might incorrectly use sig not realizing that it's still
pointing to the child->signal, so I think it would be better to keep
the unnecessary chunk for now.  Or we can introduce separate variables
for child and parent.  Hmmm... yeah, that actually would be better, I
think.

Thanks.

-- 
tejun
