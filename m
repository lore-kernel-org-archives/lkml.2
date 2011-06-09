Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1FIMAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:00:15 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36397 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab1FIMAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:00:11 -0400
Message-ID: <4DF0B5C2.6030500@mev.co.uk>
Date: Thu, 9 Jun 2011 13:00:02 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110526 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: dyna_pci10xx: replace semaphore with
 mutex
References: <20110609115215.GA14569@mail.fossee.in>
In-Reply-To: <20110609115215.GA14569@mail.fossee.in>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 12:52, Prashant P. Shah wrote:
> -	sema_init(&devpriv->sem, 1);
> +	mutex_init(&devpriv->mutex);
>  	dev->board_ptr = &boardtypes[board_index];
>  	devpriv->pci_dev = pcidev;

You could call mutex_destroy() in your _detach routine as well.  It's
used for debugging mutexes:

static int dyna_pci10xx_detach(struct comedi_device *dev)
{
	if (devpriv && devpriv->pci_dev) {
		comedi_pci_disable(devpriv->pci_dev);
		mutex_destroy(&devpriv->mutex);
	}
	return 0;
}

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
