Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0KCGnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:43:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753019Ab0KCGnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:43:07 -0400
Date: Tue, 2 Nov 2010 02:21:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
        Valdis.Kletnieks@vt.edu, Dave Airlie <airlied@gmail.com>,
        codalist@telemann.coda.cs.cmu.edu,
        ksummit-2010-discuss@lists.linux-foundation.org,
        autofs@linux.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Andrew Hendry <andrew.hendry@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Message-ID: <20101102012135.GB2648@ucw.cz>
References: <201009161632.59210.arnd@arndb.de>
 <201010192140.47433.oliver@neukum.org>
 <20101019202912.GA30133@kroah.com>
 <201010192244.41913.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010192244.41913.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -79,6 +79,10 @@ static struct drm_driver driver = {
>  
>  static int __init i810_init(void)
>  {
> +	if (num_present_cpus() > 1) {
> +		pr_err("drm/i810 does not support SMP\n");
> +		return -EINVAL;
> +	}
>  	driver.num_ioctls = i810_max_ioctl;
>  	return drm_init(&driver);

Umm, and now someone onlines second cpu?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
