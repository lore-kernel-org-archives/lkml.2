Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab1AMLG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:06:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59312 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1AMLG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xQVz3bCiSgTqYW6rY27KgdNMPRAi4TID5GWU4rmWml8iqj9yPchJIA6rMvpex52ntQ
         1DTmPART6FNQnNJ1zbVT5Irbgu2jbxetV08n7X3AzCaiYOi7EmbSzNKEBBRrKheuxin7
         MESJ8pnPLLsx6fL9K/Y09wd9E57MfljvwR/U4=
Date: Thu, 13 Jan 2011 12:06:40 +0100
From: Tejun Heo <tj@kernel.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Milan Broz <mbroz@redhat.com>, Valdis.Kletnieks@vt.edu,
        Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113110640.GC30719@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2E6129.8000700@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 11:19:21AM +0900, Jun'ichi Nomura wrote:
> > "block: simplify holder symlink handling"
> > 
> > dm linear just claims device in table constructor, I don't think it is bug in DM code.
> 
> The patch assumes only one holder disk for a claimed dev, which is not true.
> E.g. if there are multiple LVs on a PV.
> 
> In addition to that, since claiming is done in table constructor,
> there can be 2 claim instances for a slave/holder pair at a time
> when you load a table while there's already an active one.
> E.g. if you do lvresize.
> We need consideration for this, too.

Urgh... gees, so there actually was a user using all that cruft.
Sorry about the breakage, I'll see how multiple symlinks can be
restored.  I'm curious why this was added at all tho.  What was the
rationalization?  It's not like two subsystems can share the same
block device so marking the currently owning subsystem should have
been enough at the block layer.  There is no reason for block devices
to present information which is of no use to itself.  All that's
necessary is "this is taken by dm or md for more information, query
those".  dm and md need their own conf/representation layer anyway.

Thanks.

-- 
tejun
