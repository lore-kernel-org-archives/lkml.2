Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab1ETHVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:21:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59177 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614Ab1ETHVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hSsG5AwrO3FTd02oFG8tbWwaD2W3ABuxSSsstNn3N9kiyYI++7zYngkHjS82nKhNfo
         mdqs9W7t3T1s41p2jynx6cLAHzWxHtT2XvNZ+G7fhEAAjrGpu1Jbs/UiSeZPxxzFQMki
         CiRL7WTMw/Oa+KV12LZ/VLVgAxIOc7FlBXLfc=
Date: Fri, 20 May 2011 10:21:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kstrtox: drop kstrtol()/kstrtoul() when possible
Message-ID: <20110520072117.GA26787@p183>
References: <20110520061259.GA13483@p183>
 <BANLkTi=2yReXfrr7swhys7TgkuJ5r97jqQ@mail.gmail.com>
 <20110520064827.GA14185@p183>
 <20110519235449.ac0ac1c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519235449.ac0ac1c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 11:54:49PM -0700, Andrew Morton wrote:
> On Fri, 20 May 2011 09:48:27 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Fri, May 20, 2011 at 08:20:42AM +0200, Geert Uytterhoeven wrote:
> > > On Fri, May 20, 2011 at 08:15, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > > If "long" and "long long" types are identical at runtime,
> > > > kstrtol() can be aliased to kstrtoll().
> > > >
> > > > Unfortunately, one can't write
> > > >
> > > > __ __ __ __#if sizeof(long) == sizeof(long long) ...
> > > 
> > > One can write #ifdef CONFIG_64BIT instead.
> > 
> > And alignment will match, on any arch, now and in future?
> > I don't think so.
> 
> Don't worry about it.
> 
> z:/usr/src/linux-2.6.39> grep -r "#[    ]*if.*CONFIG_64BIT" . | wc -l
> 547
> 
> So much other stuff will break that kstrtofoo is a drop in the bucket.

Meh.
The point was that patch is obviously correct and will work in future.
CONFIG_64BIT means many things and you guys ask me to overload CONFIG_64BIT
one more time.

On X32, CONFIG_64BIT trick already doesn't technically work.
