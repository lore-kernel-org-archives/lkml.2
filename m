Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1AaLAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:00:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1AaLAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rCht5Cqg7Iiej3I3sOdQ2hbQv1h5fgGDEriBaGSCGX8q3Av0Tfl2CDKdMi9qXxocEm
         0eteGqfM55lx2t/uFOzQeH1dhAgP241y7gqnfDZmNK3x4BnfUC1Z0s//OdRfQ9Zv7+/g
         i4x+2Qre9zx20rx3s0x7du0QrsvXEUbt0bBa8=
Date: Mon, 31 Jan 2011 12:00:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 06/10] signal: fix premature completion of group stop
 when interfered by ptrace
Message-ID: <20110131110007.GF7459@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-7-git-send-email-tj@kernel.org>
 <20110128212257.9C18B183C1E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128212257.9C18B183C1E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 28, 2011 at 01:22:57PM -0800, Roland McGrath wrote:
> It feels nasty to add a word to task_struct just for this.
> I don't see another place to store such bookkeeping bits.

I have plans on separate out ptrace related stuff from task_struct so
that they're allocate iff they're used which will save some tens of
bytes on the task struct, so there at least is a plan to compensate
for the added cruft.

> But I'm not entirely convinced that we'll really need them when we
> conclude on fully cleaning up the whole picture.

I really don't know at this point.  I tried to make it share one of
the related fields but there needs to be a per-task field which is
protected by siglock and there currently isn't any, so...

Thanks.

-- 
tejun
