Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0GDVAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 17:00:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab0GDU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 16:59:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Date: Sun, 4 Jul 2010 22:59:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-2-git-send-email-arnd@arndb.de> <20100704073050.GA31823@merkur.ravnborg.org>
In-Reply-To: <20100704073050.GA31823@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007042259.38633.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19v1cla95EZQpBAXy0wAzsM53dVlEDjjWG41Gw
 Okqy2OxIyuJH/SyWyi3xJ0lGyAJ83XD8fKAm0hqD1DDkU8pkZa
 hDov/FnljXC8r8/XUidxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 July 2010 09:30:50 Sam Ravnborg wrote:
> >  	default:
> >  		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
> > -		return -ENOTTY;
> > +		ret = -ENOTTY;
> >  	}
> > +	unlock_kernel();
> >  
> >  	return 0;
> >  }
> You are loosing the return result here in the two error situations above.
> Initialise ret to 0 and return ret seems the easy way to do it.
> 
> The rest looked ok - I only looked at the patches.

Good catch, thanks!

I've updated the patch and pushed it out to my git tree.

	Arnd
