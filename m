Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0KOHVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:21:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44005 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab0KOHVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=Ri4ZhPCz0ba4Df5fivm6KmeyblLPe3AiL6lOJEBtXdPWxsNLkJ+vdjHDrkVIyutb2d
         Aic0Krab6o98aKNy22p9JiIMsXvv9EiBMXZ5pEZPjvBl1Sj7dQpmzgE65oDNGtnzLBbo
         bt1sFCaWKjdLF944vWwlwgLpSvawN3IDqISio=
Date: Mon, 15 Nov 2010 10:20:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] fbcmap: integer overflow bug
Message-ID: <20101115072014.GB21614@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20101027093716.GD6062@bicker>
 <20101105134018.2c11f283.akpm@linux-foundation.org>
 <20101113100718.GB1795@bicker>
 <20101115044820.GA8489@linux-sh.org>
 <AANLkTin0T5FN6WhUj0csypR=j0UPRbeHN+HC3N9xnk7E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin0T5FN6WhUj0csypR=j0UPRbeHN+HC3N9xnk7E@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 07:56:05AM +0100, Geert Uytterhoeven wrote:
> On Mon, Nov 15, 2010 at 05:48, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Sat, Nov 13, 2010 at 01:07:18PM +0300, Dan Carpenter wrote:
> >> @@ -256,8 +264,12 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
> >>       int rc, size = cmap->len * sizeof(u16);
> >>       struct fb_cmap umap;
> >>
> >> +     if (cmap->len * 2 > INT_MAX)
> 
> Isn't that another integer overflow? I.e. should be "if (cmap->len >
> INT_MAX / sizeof(u16))" instead?
> 

Yeah it is.  :/

I'll change it to:
	if (size < 0 || size < cmap->len)
like Paul asked.

regards,
dan carpenter

