Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0K2B04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:26:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40343 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0K2B0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:26:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=OBDuqbhwaYwR1MuQjXZy/NYfU0o7rFP54DJD2YyZeWe6VhSsCaDiUdVhDkJeACTS2w
         C4pRgU9501y7LFBnPQM8zoFpux3zL+/HIm1SQR/lbN7iikyPCFFAvDG6PML8oVvPNrDe
         GGmIV4fx/YDqgbP3PrJyAau/lK+UkyviiI0k4=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lisa Milne <lisa@ltmnet.com>, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
In-Reply-To: <20101128234634.461daec4@pyx>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
	 <1290961207.13526.31.camel@cai.gentoo>  <20101128234634.461daec4@pyx>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 09:28:03 +0800
Message-ID: <1290994083.877.13.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-28日的 23:46 +0000，Alan Cox写道：
> Which bit - lots of people own different parts of it, because there is a
> lot of it, and people own different sections of currently ongoing
> projects. Plus the X DRM folks own the KMS framebuffers, various authors
> own their own low level drivers for each card and so on.
> 
> I kind of own the drivers/tty/vt* bits.

Don't you see the cosole code ? There is TODO that say , "hey , I need
UNICODE support..."

I'm not breaking old one to introduce new feature, but fix a little BUG
in the TODO list. 

> I simply don't see how you are going to address the majority of the
> worlds languages in kernel space, all the major ones are too complex and
> pango is too big and complex to put in kernel as are the needed font
> renderers. Most of the needed compositing accelerations are also not
> directly exposed in KMS to the console driver as would be needed

Simply drawing characters won't need any hw acceleration. It doesn't
matter if it is slow. KMS and Wayland will make more people work under
console, trust me.

> 
> Your other problem is mode setting, VESA is on its way out, a lot of
No, VESA will still be here for another decades. Some fb driver conflict
with the X one, even there is a fb driver for you card, you simply won't
use it unless it does not conflict with X one. My PC , for example,
nvidiafb conflict with X one, so I have to use VESA.

> devices today, especially non X86 ones pretty much need X to do any kind
> of video management beyond "here is how the firmware console was
> configured", and indeed many embedded devices don't have an VT code
> enabled at all, just a printk console and possibly ttyprintk, both of
> which may well only be talking to the debug ports
> 
> Alan

printk console , if redirect to a ttyS? , then the outer Linux world
terminal will do UNICODE handling. 



