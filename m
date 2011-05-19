Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab1ESWpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:45:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESWps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=PZyeS03azUbDOabZyHvRQbElhk3U4S9sbxBNZL/aE5h0DGy3IfcLzepSnU7T61Ix3L
         7z7Q3yamWMVPp3mmzPOzR+N7WJlgMjZlVEpcsgpB/6oW/BHYG9M0HwNzp7QtmUB1mxPI
         u97X2EWCjwzKwYZBOzZr9Bfqhpwk4n2z4OVaU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#2
Date: Fri, 20 May 2011 00:45:44 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <BANLkTinXfXa8+xUSPPy46uY0Rk1e6xdPLg@mail.gmail.com>
In-Reply-To: <BANLkTinXfXa8+xUSPPy46uY0Rk1e6xdPLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201105200045.44333.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011 17:04, Linus Torvalds wrote:
> On Mon, May 16, 2011 at 11:17 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > This is the second try at implementing PTRACE_SEIZE/INTERRUPT and
> > group stop notification.  Notable changes from the first take[1] are,
> >
> > * Prep patches moved to a separate patchset[2].
> 
> So having followed the discussion so far, quite frankly I'm not
> convinced this series is 2.6.40 material.
> 
> I think that conceptually the split-up of PTRACE_ATTACH into
> SEIZE/INTERRUPT might be fine, but I don't think the interface is
> necessarily cooked, and perhaps more importantly I'm not at all sure
> that the (few) current users of ptrace() would even switch over.

I will push strace to at least use what we already have (TRACESYSGOOD etc).

> So I think Oleg's branch with cleanups is probably ready, and maybe a
> few of the preparatory patches from this branch can be merged, but I
> would _strongly_ suggest that the plan for 2.6.40 should be to not
> actually mess with interfaces to the kernel, but just cleaning up the
> actual internal implementation. I would like to keep 2.6.40 small and
> simple.

strace wasn't handling ^Z correctly for many years. It definitely can wait
for another kernel release cycle.

-- 
vda
