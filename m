Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1B1V1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:27:36 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51228 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1B1V1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:27:35 -0500
Date: Mon, 28 Feb 2011 22:26:38 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        tglx@linutronix.de, sshtylyov@mvista.com, arnd@arndb.de,
        amit.chatterjee@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
Message-ID: <20110228212638.GB16806@local>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com>
 <1298926895-5294-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298926895-5294-2-git-send-email-pratheesh@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 02:31:35AM +0530, Pratheesh Gangadhar wrote:
> +
> +		/* Register PRUSS IRQ lines */
> +		p->irq = IRQ_DA8XX_EVTOUT0 + cnt;
> +		p->handler = pruss_handler;
> +
> +		ret = uio_register_device(&dev->dev, p);
> +
> +		if (ret < 0)
> +			goto out_free;
> +	}
> +
> +	spin_lock_init(&lock);

That's too late. uio_register_device() enables the irq, and your spin_lock
is not ready at that time.

> +	platform_set_drvdata(dev, info);
> +	return 0;
> +
> +out_free:
> +	pruss_cleanup(dev, info);
> +	return ret;
> +}

Thanks,
Hans

