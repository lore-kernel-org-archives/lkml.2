Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1FPPSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:18:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45536 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab1FPPSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UWfcyrz5xZwf+fUyc5nYZ3NoMCQLyhlq1V1e8ETEtkXAirRzJY4ILXCcenO7n2fi9n
         l+SeJ8LaRK+VIQbIYnRiXn8vu1y+AxB54+vNrbjEOOzDSFEHqgeaprtXKzJqKVV+g1nl
         vaDbq4MmmmSGtgiEHaBejFQ8GiZCnyZlpV3RY=
Date: Thu, 16 Jun 2011 17:18:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: scheduler / perf stat question about CPU-migrations
Message-ID: <20110616151836.GC23624@somewhere.redhat.com>
References: <E1QXDpy-0007Wr-5V@tytso-glaptop>
 <20110616150347.GB23624@somewhere.redhat.com>
 <4DFA1D07.1050705@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DFA1D07.1050705@draigBrady.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 04:11:03PM +0100, Pádraig Brady wrote:
> On 16/06/11 16:03, Frederic Weisbecker wrote:
> > On Thu, Jun 16, 2011 at 10:46:26AM -0400, Theodore Ts'o wrote:
> >> Can someone tell me how I'm being confused?
> >>
> >> I ran the following command as root:
> >>
> >> 	perf stat schedtool -a 1 -e e2fsck -ft /dev/funarg/kbuild
> > 
> > A theory is that schedtool does:
> > 
> > if (!fork()) {
> > 	set affinity there
> > 	launch e2fsck
> > }
> 
> Well `taskset` and `chrt` from util-linux don't fork at least,
> so you could try those instead.

Even if they don't fork and change their own affinity, you'll get
migrations that happened since taskset/chrt were launched.

The only solution is too set perf affinity itself:

	schedtool -a 1 -e perf stat -- e2fsck -ft /dev/funarg/kbuild

Taskset would work too.

> 
> I also suggest protecting the command with --
> in case perf is not stopping at the first unrecognized option.
> 
> cheers,
> Pádraig.
