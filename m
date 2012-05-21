Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2EUIq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:46:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36683 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756777Ab2EUIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:46:25 -0400
Date: Mon, 21 May 2012 10:46:20 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd: lm3533: fix return type of attribute is_visible
Message-ID: <20120521084620.GC21033@localhost>
References: <1336725641-11826-1-git-send-email-jhovold@gmail.com>
 <20120518111804.GA20467@localhost>
 <20120520131908.GV12015@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120520131908.GV12015@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 03:19:08PM +0200, Samuel Ortiz wrote:
> Hi Johan,
> 
> On Fri, May 18, 2012 at 01:18:04PM +0200, Johan Hovold wrote:
> > Hi Samuel,
> > 
> > On Fri, May 11, 2012 at 10:40:41AM +0200, Johan Hovold wrote:
> > > Since commit 587a1f1659 ("switch ->is_visible() to returning umode_t")
> > > the return type of is_visible is umode_t rather than mode_t.
> > > 
> > > This silences a compiler warning on some architectures where these types
> > > are not compatible.
> > > 
> > > Reported-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > > ---
> > 
> > Apparently Dan Carpenter sent a fix for this compiler warning the day
> > after I submitted mine. Dan's patch, however, only fixed the return type
> > and not the type of the mode variable.
> > 
> > Could you consider applying this patch one on top of Dan's (which you
> > applied to mfd-next on Monday)?
> I applied the following chunk:
> 
> @@ -367,7 +367,7 @@ static umode_t lm3533_attr_is_visible(struct kobject *kobj,
>         struct device_attribute *dattr = to_dev_attr(attr);
>         struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(dattr);
>         enum lm3533_attribute_type type = lattr->type;
> -       mode_t mode = attr->mode;
> +       umode_t mode = attr->mode;

Great. Thanks!

Johan
