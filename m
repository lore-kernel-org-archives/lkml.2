Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0EORIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 13:08:24 -0400
Received: from mail001.aei.ca ([206.123.6.130]:55764 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab0EORIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 13:08:22 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Defrag in shrinkers
Date: Sat, 15 May 2010 13:08:17 -0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.4-crc; KDE/4.4.3; x86_64; ; )
Cc: Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, npiggin@suse.de
References: <1273821863-29524-1-git-send-email-david@fromorbit.com> <alpine.DEB.2.00.1005141244380.9466@router.home> <87y6fmmdak.fsf@basil.nowhere.org>
In-Reply-To: <87y6fmmdak.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005151308.18090.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010 16:36:03 Andi Kleen wrote:
> Christoph Lameter <cl@linux.com> writes:
> 
> > Would it also be possible to add some defragmentation logic when you
> > revise the shrinkers? Here is a prototype patch that would allow you to
> > determine the other objects sitting in the same page as a given object.
> >
> > With that I hope that you have enough information to determine if its
> > worth to evict the other objects as well to reclaim the slab page.
> 
> I like the idea, it would be useful for the hwpoison code too,
> when it tries to clean a page.

If this is done generally we probably want to retune the 'pressure' put on the slab.  The
whole reason for the callbacks was to keep the 'pressure on the slab proportional to the
memory pressure (scan rate).  

Ed Tomlinson
