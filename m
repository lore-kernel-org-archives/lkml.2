Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1GUT75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:59:57 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:59964 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751777Ab1GUT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:59:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=E7+j3BwGhO1zgIiKt+a6esIwPnqUcEBTjS87RqLYKcMMQaEDAJjGG21wxAnLbyzo6Wl8OgD0Ih5wb7wRWXa14xhq8+NDcQIJDgJtoeHRYfPbOPHSFzJ5UXc74A/FZMYQ;
Date: Thu, 21 Jul 2011 12:59:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: PCI config space accessor functions should not
 ignore the segment argument
Message-ID: <20110721125949.3fa2dc41@jbarnes-desktop>
In-Reply-To: <20110721090539.GK9216@elte.hu>
References: <4E258BD6020000780004E3BE@nat28.tlf.novell.com>
	<20110721071021.GC9216@elte.hu>
	<4E27F346020000780004EBA4@nat28.tlf.novell.com>
	<20110721090539.GK9216@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 11:05:40 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > > also, the analysis/explanation is a bit incomplete:
> > >   
> > >> The access method 1 accessor, as it can be used for extended 
> > >> accesses (on AMD systems) instead gets added checks for the 
> > >> passed in segment to be zero (returning an error just like out 
> > >> of range values of the other arguments would cause).  
> > > 
> > > Under what circumstances can this trigger in practice, with the 
> > > current code?  
> > 
> > I really don't know whether multi-segment PCI systems with AMD CPUs 
> > are existing in practice. If they do, and if MMCFG cannot be used 
> > there for whatever reason, accesses to segments other than zero 
> > would get issued to the wrong device(s). I would have thought that 
> > this is what the paragraph above says, but I certainly can add this 
> > more explicit description...  
> 
> Do we have to re-discuss the upstream changelog policy every single 
> time again?
> 
> Yes, overly verbose, reader-friendly changelogs are preferred over 
> 'anyone who is an expert in this field should know all the 
> expectations, status quo and consequences' kind of minimalistic 
> changelogs.
> 
> The former is consciously information-rich and robust, the latter is 
> information-poor and prone to be fragile, prone to be ambiguous, 
> making both the merge flow, any bug and commit triage and eventual 
> later fixes more difficult.

I did a double take on the original, so yeah more verbose would be
good.  But generally you're right we should flag this kind of incorrect
usage, so from that perspective the patch looks good.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
