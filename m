Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab0J0AkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:40:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab0J0AkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rQ9ucvrBW2DLhSrTBjw4768gYA+b+lsJbUKaefu2RWo1yoY/8f71aRrzhKVvUE78Wv
         vyLYsCXa3UMmpAg7OTOsYrjsjCM5xKKTTiwyvFzmYMRSs1cNxDbOwzVFr/JlAn1gSumy
         iuBzJE2TcRnygQ5Xtdc9A/f3aOo0NNNKzGSY8=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>, pr_fmt. Fix dbg and __FILE__ use
Date: Tue, 26 Oct 2010 17:40:13 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-61.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1288059486.git.joe@perches.com> <20101026155028.GA13097@core.coreip.homeip.net> <1288135531.4145.59.camel@Joe-Laptop>
In-Reply-To: <1288135531.4145.59.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010261740.13566.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 26, 2010 04:25:31 pm Joe Perches wrote:
> On Tue, 2010-10-26 at 08:50 -0700, Dmitry Torokhov wrote:
> > Hi Joe,
> 
> Hi Dmitry.
> 
> > On Mon, Oct 25, 2010 at 07:44:24PM -0700, Joe Perches wrote:
> > > Standardized message logging prefixes.
> > > Removed \n from dbg macro, added \n to each dbg call site.
> > 
> > Did you test it? It looks for call like:
> > > +             dbg("%02x <- i8042 (flush, %s)\n",
> > > +                 data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
> > 
> > the result will be:
> > printk(KERN_DEBUG "i8042: %02x <- i8042 (flush, %s)\n [%d]", ...)
> > which is not exactly what you want...
> 
> Right.  My mistake.
> I compile tested only and didn't notice the badly formed string.
> 
> Mind if I move the time to the front like this?
> 
> +#define dbg(format, arg...)                                            \
> +do {									\
> +	if (i8042_debug)						\
> +		printk(KERN_DEBUG KBUILD_MODNAME ": [%d]" format),	\
> +                      (int)(jiffies - i8042_start_time), ##arg);	\
> +} while (0)

Another option would be to leave '\n' in dbg() and leave most of the
callers as is.

Thanks.

-- 
Dmitry
