Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0FUJML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:12:11 -0400
Received: from smtp.mmd.net ([80.83.0.30]:47895 "EHLO smtp.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab0FUJMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:12:07 -0400
Message-ID: <4C1F2CE4.20502@ebts.fi>
Date: Mon, 21 Jun 2010 12:12:04 +0300
From: Aleksandr Koltsoff <aleksandr.koltsoff@ebts.fi>
Organization: EKE Building Technology Systems
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: Exporting NOCMTIME to userspace
References: <4C1F087E.7070000@ebts.fi> <871vc0darq.fsf@basil.nowhere.org>
In-Reply-To: <871vc0darq.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Aleksandr Koltsoff <aleksandr.koltsoff@ebts.fi> writes:
>> On the other hand, if someone can suggest a way to avoid timestamp
>> updates/causing inode writes, I'm all ears and eyes. (using the
>> block-layer directly or writing a custom fs is not really an elegant
>> solution, IMO).
> 
> I think what would be better would be to have flush intervals
> that specify that m/c time are only flushed with longer 
> intervals (similar to the deferred atime that's now in there)
> 
> This would still cause the inode to be written if it gets flushed from
> memory on low memory and occasionally depending on the interval, but
> most of the writes would be gone. All still with the same semantics.

While this might solve the performance aspect of the problem, it will
only migitate the reliability aspect with NANDs, since the inodes will
eventually be flushed anyway (thus causing irreversible wear).

Also, a tunable like you're suggesting would affect all files on a
single filesystem, instead of just a subset of files. Having an option
to "disable" m/ctime updates per file would be optimal in our case,
since we're talking about several years of runtime with the use case.
There are other issues with rrdtool which make this hard, but those are
all solvable without kernel modifications.

That said, the migitative solution would be better than none :-).

Regards,

ak.
