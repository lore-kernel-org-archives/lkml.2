Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0IEUaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 16:30:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46135 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0IEUaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 16:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bFXa1lKOnkmnp6BFNrB6KwD8pJasJy6hOB5WZ3vTgui2LZLYxAi54nJ4U3uPzAR3sx
         E0h++pxEkOxCycjrjub5vWcdJ+VAYPEUBPJFCnkg19WT7GHvrx6xqO2Qk999dY/Z4gej
         eOF840lN1FTZq7ssS6lxqC+3qpitZqskM0cPs=
Date: Sun, 5 Sep 2010 13:30:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
 module
Message-ID: <20100905203006.GD18411@core.coreip.homeip.net>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> +
> +static void tcm_loop_primary_release(struct device *dev)
> +{
> +	return;
> +}
> +
> +static struct device tcm_loop_primary = {
> +	.init_name		= "tcm_loop_0",
> +	.release		= tcm_loop_primary_release,
> +};
> +

No, you can not have statically allocated devices and dummy release
functions.

-- 
Dmitry
