Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab2C2TyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab2C2TyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:54:02 -0400
Date: Thu, 29 Mar 2012 15:53:54 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329195354.GA11790@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20120329155542.GA31285@redhat.com>
 <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
 <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 11:36:49AM -0700, Linus Torvalds wrote:
 > On Thu, Mar 29, 2012 at 11:26 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Thu, Mar 29, 2012 at 09:03:31AM -0700, Linus Torvalds wrote:
 > >  > Can you do sysrq-w (or whatever it is that does only the D-state
 > >  > processes)? That might give the more relevant process information without
 > >  > everything else making it unreadable...
 > >
 > > http://codemonkey.org.uk/junk/process-trace2.txt
 > 
 > Ok, this doesn't look all that different, but now it's not truncated
 > any more because the random "waits for children or poll" cases are
 > gone.
 > 
 > It's still basically all blocked on the ext4 journal. All writes as
 > far as I can see.
 > 
 > That said, there's that odd kworker/1:2 there that seems to be
 > constantly running. Can you get the EIP for that one (several times)
 > by doing sysrq-p (or maybe sysrq-l is better - that should give the
 > stack trace too).

Took a while to reproduce that time (but now I have a theory, going
to try and reproduce that after sending this mail).

sysrq-p looks kinda boring. I couldn't get sysrq-l to coincide
with kworker running.

http://codemonkey.org.uk/junk/process-trace3.txt

	Dave

