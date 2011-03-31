Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1CaOVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:21:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48548 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1CaOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=ia40kCYvy6OkTcGxD4q/hRYtg00h0YS+fMtfkJdI8AT3QPBrJNq7bZh6uNrVQvVJSY
         ukDxvpP1LHjURg30MOzaf5pPYj+ha8T0AWcFpoFyv3qeOHtPIrWHDOM2d/daeaGR1ZAP
         9wZswBKcU85dn9GGogtAhsR93vcOWL3e8BdT4=
Date: Thu, 31 Mar 2011 11:21:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331142135.GB25095@ghostprotocols.net>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com>
 <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 30, 2011 at 10:32:11PM -0700, Linus Torvalds escreveu:
> On Wed, Mar 30, 2011 at 8:55 PM, Dave Jones <davej@redhat.com> wrote:
> > I tried that, and wasn't particularly enlightened.
> >
> > +      6.53%  kworker/1:2  [kernel.kallsyms]  [k] read_hpet
> > +      4.83%  kworker/0:0  [kernel.kallsyms]  [k] read_hpet
> 
> Go into those, deeper into the callchain. That's how to see what the
> upper-level problem is - by seeing who actually calls it. The leafs
> themselves (where the time is obviously spent) don't tend to be very
> informative, no.

Yeah, please press 'E' since you're using the TUI, where you can expand
collapse callchains in all its levels.

Pressing 'E' will expand all of them, 'C' will collapse it all. Enter on
lines with a '+' will expand just that one, etc.

Press 'h' to get more help.

Or use 'perf report --stdio' and you'll get it all expanded and in plain
text.
 
- Arnaldo
