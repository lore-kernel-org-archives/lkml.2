Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab0HLHPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:15:05 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51065 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab0HLHPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hqvQHo6v281gmf2QT33/ZBs6VAJFIqXsNgZd8tqFuajrwpo2haIEZ3Gm0cZ5wBDk4D
         QMmh/jnoY9TNuOwlq899pRK4pfvogORo1xvvhAF/LGIK84RU/fS4oKEZs/zVfC3LlLum
         2XwyydYEbpVr2Jb/ma7qFU+VKvdRkxx8DXvBU=
Date: Thu, 12 Aug 2010 09:14:31 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of
	list_for_each_entry loop cursor
Message-ID: <20100812071431.GF645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>, Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Sunil Mushran <sunil.mushran@oracle.com>
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk> <20100812000355.GA7195@mail.oracle.com> <Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 07:46:13AM +0200, Julia Lawall wrote:
> 
> This seems a bit ugly to me, since it exposes the implementation of the 
> list abstraction.  What about the following:
> 
> lock = NULL;
> list_for_each_entry(x, tmpq, list) {
> 	if (x->ml.cookie == ml->cookie) {
> 	   	lock = x;
> 		break;
> 	}
> }
> 

I agree with you that it's ugly as pants.  Maybe someone could write an
at_list_start() macro?

regards,
dan carpenter
