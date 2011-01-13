Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1AMNM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:12:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1AMNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X+odb53WMA2mIp3kidYeWxOcy8ueyw541282/PvTEgrYzYqavUVvY9W8XAspGtlfAl
         e8g+h1X8mPQzcuJY28OtvtKKlsIJ0SDRAFYLeBJJw/dkglGQapzU3tmaciCMTcyRN31p
         pKeWDLtUDBGR5yMIpjJsE1C7LdwS+0ZT9mSC8=
Date: Thu, 13 Jan 2011 14:12:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113131216.GF30719@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
 <20110113110640.GC30719@htj.dyndns.org>
 <4D2EE156.1050006@redhat.com>
 <20110113122701.GG16523@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113122701.GG16523@nb.net.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 01:27:01PM +0100, Karel Zak wrote:
>  We also use holders/slaves links in libblkid to evaluate dependencies
>  between devices (since 2008).
> 
> > Whatever changes are needed, please keep this functionality, it
> > can be useful.
> 
>  Definitely.

Yeah, sure, it's not like I can afford to avoid fixing it at this
point anyway, but I still want to point out it's at the wrong layer
and shouldn't have been added like this, really.  If you want blkid to
identify it, the proper thing to do would be querying blk device for
the claimer and then use claimer-specific method to query them.  It's
not like the current method would make sense for btrfs or whatnot.

So, yeap, I definitely am fixing it but let's not do things like this
in the future.

Thanks.

-- 
tejun
