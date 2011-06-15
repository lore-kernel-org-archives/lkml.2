Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1FOOpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:45:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34223 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1FOOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kLCNY6n8EHXCt29LXrXAJ3eeU2zEllTNMnHHdTdJomqP/fCV1d2E6HKukzM2xwv0vx
         qBd30eCTrG/u0dWzc4n0gxsHGGAT+khqkA6IMhjt92beqlF/DpkG/3e5AAUTP7x+NyqP
         gWA+z4fl4arXVa8qtqohleVmzWw1HAo9MSwc8=
Date: Wed, 15 Jun 2011 16:45:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH 03/16 v2] tracing: Add a proc file to stop tracing and
 free buffer
Message-ID: <20110615144525.GB17204@somewhere>
References: <20110615134841.767565350@goodmis.org>
 <20110615135233.415290242@goodmis.org>
 <20110615142523.GA17204@somewhere>
 <1308148989.9218.127.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308148989.9218.127.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:43:09AM -0400, Steven Rostedt wrote:
> On Wed, 2011-06-15 at 16:25 +0200, Frederic Weisbecker wrote:
> > On Wed, Jun 15, 2011 at 09:48:44AM -0400, Steven Rostedt wrote:
> > > From: Vaibhav Nagarnaik <vnagarnaik@google.com>
> > > 
> > > The proc file entry buffer_size_kb is used to set the size of tracing
> > > buffer.
> > >
> > > The memory to expand the buffer size is kernel memory. Consider
> > > a use case where tracing is handled by a user space utility, which acts
> > > as a gate keeper for tracing requests. In an OOM condition, tracing is
> > > considered a low priority task and if the utility gets killed the ring
> > > buffer memory cannot be released back to the kernel.
> > > 
> > > This patch adds a proc file called "free_buffer" whose purpose is to
> > > stop tracing and free up the ring buffer when it is closed.
> > > 
> 
> > 
> > s/proc/debugfs, right?
> 
> Oops, I didn't even notice it said that. But you are correct, the patch
> adds a debugfs not a proc file.
> 
> Not sure it's worth redoing for the changelog though :-/

No big deal, I just wanted to ensure I didn't miss something in the diff.
