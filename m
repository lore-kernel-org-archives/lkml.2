Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab1ESPTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:19:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab1ESPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XFO+ftxACFC1lzHMkAqo2dj7BaTImRbt7ds1qLGueqMrJaDwYIJW6456eG0a0QDstd
         Td0ERRl97HTItPuPau+IWJrtdR0MWVBllHHcUONNIyj1thJMheEOkdYPteGme++U3u0a
         fVd2aVRgb3ZjY74iiEZUme1jqyD5672qZBwW8=
Date: Thu, 19 May 2011 17:19:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#2
Message-ID: <20110519151922.GL627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <BANLkTinXfXa8+xUSPPy46uY0Rk1e6xdPLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinXfXa8+xUSPPy46uY0Rk1e6xdPLg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Thu, May 19, 2011 at 08:04:28AM -0700, Linus Torvalds wrote:
> On Mon, May 16, 2011 at 11:17 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > This is the second try at implementing PTRACE_SEIZE/INTERRUPT and
> > group stop notification.  Notable changes from the first take[1] are,
> >
> > * Prep patches moved to a separate patchset[2].
> 
> So having followed the discussion so far, quite frankly I'm not
> convinced this series is 2.6.40 material.

Definitely not.  The interface is not even fixed/complete yet.  I
think we should document the whole ptrace, job control and signal
interaction properly before committing to the interface.

> I think that conceptually the split-up of PTRACE_ATTACH into
> SEIZE/INTERRUPT might be fine, but I don't think the interface is
> necessarily cooked, and perhaps more importantly I'm not at all sure
> that the (few) current users of ptrace() would even switch over.

I think it shouldn't be too difficult for strace.  gdb would be a
challenge tho.  At any rate, given that the existing mechanism is
simply broken, I'm hoping they would switch over soonish.

> So I think Oleg's branch with cleanups is probably ready, and maybe a
> few of the preparatory patches from this branch can be merged, but I
> would _strongly_ suggest that the plan for 2.6.40 should be to not
> actually mess with interfaces to the kernel, but just cleaning up the
> actual internal implementation. I would like to keep 2.6.40 small and
> simple.

Upto the patchset which cleaned up job control notifications, Oleg's
recent sigprocmask plus some odd fix patches should be basically it
for 2.6.40.  The current ptrace branch in Oleg's tree seems to have
just that.

Thanks.

-- 
tejun
