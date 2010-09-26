Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0IZTmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 15:42:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54057 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab0IZTmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 15:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A/LWP/zIE1FJQ/FEnRkUZRSCOCLEH7s6oS/eiftbJLFB1/TTVtnxfQHFnvHAGpwZ1o
         hBr0sDag3hNCEa5FjQ5OuqBdCE+PA4yI4IrpzugnmiWaAPZ97iUXr9nCFFwA8mUgFgZq
         oteoU5Z/H1PmF7998+QgO9W1HgyajhQi6x2Kg=
Date: Sun, 26 Sep 2010 23:41:57 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix error path
Message-ID: <20100926194156.GA25491@albatros>
References: <1285491595-377-1-git-send-email-segooon@gmail.com>
 <20100926131151.GC6134@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100926131151.GC6134@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 15:11 +0200, Dan Carpenter wrote:
> On Sun, Sep 26, 2010 at 12:59:55PM +0400, Vasiliy Kulikov wrote:
> > +err_free:
> > +	for (i--; i>=0; i--) {
> > +		kfree(pdpram_blk->pbuffer);
> > +		kfree(pdpram_blk);
> > +	}
> 
> This is wrong.

Of course, I'm very careless.  Pointers are linked into the list and the right code
should loop the list and free both pointers.  I'll post patch v2 tomorrow.

-- 
Vasiliy
