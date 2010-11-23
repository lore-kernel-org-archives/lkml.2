Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab0KWFNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:13:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41531 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0KWFNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=JY61deAv2T9ebgPuI8ZqSGI8WvJPiZFxMmEAgrQMQ5H8OmJVV8BmpYoMWFKz3vGcN8
         xlG4N4rpgyTIffD3vL252VEsicaC9cCWfCoxZirKxATkwAZGD5Uf2oSfg2cJjWeexF0L
         VmSN52oA75I8JUUpIXcaxZkwrb3x9L24cJez0=
Date: Tue, 23 Nov 2010 08:12:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101123051259.GF1522@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Vasiliy Kulikov <segoon@openwall.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	kernel-janitors@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jakub Jelinek <jakub@redhat.com>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
 <20101112120834.33062900.akpm@linux-foundation.org>
 <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
 <20101114092533.GB5323@albatros>
 <20101114180643.593d19ac.akpm@linux-foundation.org>
 <1289848341.2607.125.camel@edumazet-laptop>
 <4CE268C8.5010203@panasas.com>
 <20101122155043.fbbb74f4.akpm@linux-foundation.org>
 <1290471649.2704.24.camel@edumazet-laptop>
 <20101122163234.5470e33e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122163234.5470e33e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 04:32:34PM -0800, Andrew Morton wrote:
> On Tue, 23 Nov 2010 01:20:48 +0100
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le lundi 22 novembre 2010 __ 15:50 -0800, Andrew Morton a __crit :
> > 
> > > Well.  We certainly assume in many places that
> > > 
> > > 	struct foo {
> > > 		int a;
> > > 		int b;
> > > 	} f = {
> > > 		.a = 1,
> > > 	};
> > > 
> > > will initialise b to zero.  But I doubt if much code at all assumes
> > > that this initialisation patterm will reliably zero out *holes* in the
> > > struct.
> > > 
> > 
> > We did such assertions in the past, we were wrong.

Well, that sucks...  I know I wrote some code that relied on holes
getting zeroed as well.  Is there no option to GCC to make this work?

regards,
dan carpenter

