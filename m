Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0ILUxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:53:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0ILUxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=doHDEW328Ay5rf1oOmeJgSHgBNOc/6MEBAhgGqex2V+IOUT01DxK90GA7wLLf6vEWw
         z0mWx98bG/KVT7JmtKPE+ni4XEpnVluQzOfsftsCyIeMwSJu+U1A1AUQJ93VcvSXX9Pv
         R8S8ioryBS3/1U8jIoSqL+c3TygGTJg7mJjj8=
Date: Sun, 12 Sep 2010 22:52:49 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Al Cho <acho@novell.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: keucr: check kmalloc() return value
Message-ID: <20100912205248.GE25351@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1284317808-4850-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284317808-4850-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 10:56:43PM +0400, Vasiliy Kulikov wrote:
> kmalloc() may fail, if so return error code.
> Also don't alloc 16 bytes from the heap, use stack instead.

I don't have ENE_SendScsiCmd() in my repo, but I think it's a DMA
function.  You're not supposed to use stack memory for DMA transfers.
This is documented in:  Documentation/DMA-API-HOWTO.txt

So the original code is correct here (except that there is no error
handling).

regards,
dan carpenter


