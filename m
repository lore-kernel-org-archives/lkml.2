Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1HBCWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 22:22:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab1HBCWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 22:22:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ajmysRBc0k06U/+qOgy5jMZJqUd55rv9i1p7uQB6L6+re5QGE7yOGOojpIdPx+htJ
	2lG0+WgI3y3bjm3LcGeQA==
Date: Mon, 1 Aug 2011 19:22:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
In-Reply-To: <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <20110801183207.cea89a96.akpm@linux-foundation.org> <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-852114070-1312251729=:15596"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-852114070-1312251729=:15596
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 1 Aug 2011, Linus Torvalds wrote:

> > aw, what crap.
> >
> > "/proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead."
> >
> > Once per boot.  That's not "scary".
> 
> It is when there is that totally pointless stack trace, and the kernel
> bug reporting tool picks it up and tells the user that there was a
> kernel oops.
> 
> Which it really does.
> 
> So if it was a "printk_once()" it would be fine. The WARN_ONCE() is
> just annoying.
> 

It was a printk_once() when the tunable was scheduled to be removed two 
years later.  Now that one year has passed since the oom killer rewrite 
has been merged, it was changed to a WARN_ONCE() simply to attract more 
attention to the issue.  The plan was to remove the tunable completely a 
year from now as specified in Documentation/feature-removal-schedule.txt.

The intent here was to be more helpful than annoying or causing a problem 
with a log parser that doesn't understand the different between a warning 
and a panic or oops.

We could change it to a more obvious multi-line notification that an 
application is using a deprecated interface that wouldn't parse like the 
WARN_ONCE() output if you'd like.  The single printk_once() obviously 
wasn't sufficient over the course of a year to get enough applications to 
change although things like udev, kde, and opensshd did.  chromium 
actually noticed the new WARN_ON() behavior and is in the process of 
fixing it because of that.
--397155492-852114070-1312251729=:15596--
