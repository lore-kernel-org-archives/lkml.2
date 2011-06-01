Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1FAFjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 01:39:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33932 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1FAFjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 01:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eMjOlYfjvGSsdyNTdrU4kotSaXugQgJ+HKF/Ase0LWTnnzXqcAymdimp5ebYL6udij
         ciS/L+A+lRl6nhdyRgiIxvE7nET8FgJioQ2F6mgA92l2lZW5cEJzQo/mbCQ96SOjs/4K
         NGRI40ORuUvkCn/HE1Us9kVz6W6e5urmezqxk=
Date: Wed, 1 Jun 2011 14:39:03 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
Message-ID: <20110601053903.GE23067@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <20110530154211.GA11325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530154211.GA11325@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, May 30, 2011 at 05:42:11PM +0200, Oleg Nesterov wrote:
> On 05/30, Tejun Heo wrote:
> >
> > * PTRACE_LISTEN added.  This puts tracee into quasi-active state where
> >   wait(2) and sync ptrace requests fail and tracee is allowed to
> >   re-trap into STOP to notify an async event.
> 
> Nice!
> 
> Personally, I think the whole series is fine. So far I only read it
> inline (without applying). I'll try to read it carefully patch-by-patch,
> it is always good to try to re-check the details, but I do not expect
> I'll find something which should delay this series from merging into
> ptrace tree.

Yeah, yeah, PTRACE_LISTEN turned out to be pretty easy to implement.
I didn't really have to change too much.  I'll test different corner
cases (different thread doing waking/sleeping, race against INTERRUPT
kind of things) and let you know how it goes.

Thanks.

-- 
tejun
