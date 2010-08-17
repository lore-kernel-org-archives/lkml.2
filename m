Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0HQWai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:30:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64610 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0HQWad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FUUnZoGXEoIz2GVv2TzwE9BH+ZnhikIXc23feKsabbfQSqP4bngrRmOHT1Y8M0DzPV
         zOWMZaFYTorHMC4hARdegUuMtbub+J1Fc5TRJ2p+/rGGC8xNKs+dhMmIaq0mr7Q3Jm4+
         pz2Ea4cdfphDwe+e3JSAQNq7ZJo1d/m4el2UY=
Date: Wed, 18 Aug 2010 00:30:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Benton <b3nton@gmail.com>
Subject: Re: [BUG][reiserfs] page fault during kernel boot
Message-ID: <20100817223026.GB5461@nowhere>
References: <201008171125.25956.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008171125.25956.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:25:25AM +0300, Marin Mitov wrote:
> Hi all,
> 
> The function: reiserfs_evict_inode() ends with:
> 
> <snip>
> out:
> 	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
> 	dquot_drop(inode);
> 	inode->i_blocks = 0;
> 	reiserfs_write_unlock_once(inode->i_sb, depth);
> 
> no_delete:
> 	end_writeback(inode);
> 	dquot_drop(inode);
> }
> <snip>
> 
> When goto out path is taken,
> 
> end_writeback(inode);
> dquot_drop(inode);
> 
> are executed twice, leading to page fault (in my case) during the kernel boot.
> 
> Add return; before no_delete label (but I am not quite sure that this is correct :-).
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>


In fact the sam patch has been submitted and applied to the vfs tree already:

http://lkml.org/lkml/2010/8/11/98

The patch will probably reach mainline soon.

Thanks.

