Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1BOPZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:25:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1BOPZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:25:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=oIkILNwxBHL4S/Slaa5rSUteNwJEVxCIhq2KS7tx9rLEyB+1f6IaUvRM92zpg80p6u
         c+MsTeTzw9D4zqPyalSRHXXqnMC6o60w9/t0SNBFCf16kP5hMXYbcSRahtGB25ud8s6+
         m63VCujKsyiBGVSRqEaqJzV3qig8/SYhG2OmE=
Date: Tue, 15 Feb 2011 16:20:33 +0100
From: Tejun Heo <tj@kernel.org>
To: device-mapper development <dm-devel@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Message-ID: <20110215152033.GK3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110215124629.GF5825@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 15, 2011 at 12:46:29PM +0000, Alasdair G Kergon wrote:
> On Tue, Feb 15, 2011 at 01:17:56PM +0100, Milan Broz wrote:
> >         fd = open(device, O_RDWR | flags);
> >         if (fd == -1 && errno == EROFS) {
> >                 *readonly = 1;
> >                 fd = open(device, O_RDONLY | flags);
> >         }
> 
> Would it be reasonable for your patch to return EROFS rather than
> EACCES?
> 
> man 2 open:
>        int open(const char *pathname, int flags, mode_t mode);
> 
>        EROFS  pathname  refers  to a file on a read-only file system and write
>               access was requested.
> 
>        EACCES The requested access to the file is not allowed, or search  per‐
>               mission  is denied for one of the directories in the path prefix
>               of pathname, or the file did not exist yet and write  access  to
>               the  parent  directory  is  not allowed.  (See also path_resolu‐
>               tion(7).)

Hmmm... but -EACCES is the correct one here.  The device node itself
is rejecting RW access.  There's no FS which is enforcing RO.  But if
the userland is already expecting that, dm can simply change the error
code, no?

Thanks.

-- 
tejun
