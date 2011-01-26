Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1AZOa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:30:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50475 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZOa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:30:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=OC2QDWUc86yrzuuOrSjqnuJ/W8hoY1cT744L1bsmqoulZipAKrwEFgZhCGmX2EYJPQ
         f22rvfHtrIpy+gOENpm47pF9XsNBZ5JKndmIcPLbjlhSRNXJPvSclAB82lncLgRLtSOI
         6Hb8EtkPQ9WaXdYM/klOtQf7vG4DC+4KauNjM=
Date: Wed, 26 Jan 2011 17:30:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in
 write_blk_fifo() function.
Message-ID: <20110126143045.GP2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
 <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
 <20110126130718.GN2721@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126130718.GN2721@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also when it does:
	memcpy(ft1000dev->tx_buf, *pUcFile, byte_length);

That should probably be:
	memcpy(ft1000dev->tx_buf, *pUcFile, word_length * 4);

Otherwise we're probably copying garbage from beyond the end of *pUcFile
to the ->tx_buf.  ft1000dev->tx_buf is hopefully initialized to zero at
this point?

regards,
dan carpenter

