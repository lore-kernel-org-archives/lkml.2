Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1HVVMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:12:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33218 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1HVVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:12:54 -0400
Date: Tue, 23 Aug 2011 00:10:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        ascardo@holoscopio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix possible sleep under lock
Message-ID: <20110822211035.GB12248@shale.localdomain>
References: <1314038869-8164-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20110822190936.GA12248@shale.localdomain>
 <4E52B2D9.5070904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E52B2D9.5070904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:49:45PM -0500, Seth Jennings wrote:
> Actually, should this be GFP_ATOMIC or GFP_NOWAIT?
> 

GFP_ATOMIC is sort of a good default answer.

GFP_NOWAIT is normally used when you want to do something really
fast and if the allocation fails, you don't want to wait for it.
So if memory is short, and you drop a packet?  Who cares!  TCP has
error handling built in.  Other than that, GFP_NOWAIT is used a lot
in the core kernel.

You could be right that GFP_NOWAIT is fine here.  I don't know zcache
well enough to say.  How bad is it if the allocation fails?

regards,
dan carpenter
