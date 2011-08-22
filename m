Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1HVVfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:35:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44692 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1HVVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:35:12 -0400
Message-ID: <4E52CB88.1060401@linux.vnet.ibm.com>
Date: Mon, 22 Aug 2011 16:35:04 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        ascardo@holoscopio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix possible sleep under lock
References: <1314038869-8164-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110822190936.GA12248@shale.localdomain> <4E52B2D9.5070904@linux.vnet.ibm.com> <20110822211035.GB12248@shale.localdomain>
In-Reply-To: <20110822211035.GB12248@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 04:10 PM, Dan Carpenter wrote:
> On Mon, Aug 22, 2011 at 02:49:45PM -0500, Seth Jennings wrote:
>> Actually, should this be GFP_ATOMIC or GFP_NOWAIT?
>>
> 
> GFP_ATOMIC is sort of a good default answer.
> 
> GFP_NOWAIT is normally used when you want to do something really
> fast and if the allocation fails, you don't want to wait for it.
> So if memory is short, and you drop a packet?  Who cares!  TCP has
> error handling built in.  Other than that, GFP_NOWAIT is used a lot
> in the core kernel.
> 
> You could be right that GFP_NOWAIT is fine here.  I don't know zcache
> well enough to say.  How bad is it if the allocation fails?
> 
> regards,
> dan carpenter

Meh... I think GFP_ATOMIC is fine.  If the allocation fails, then zcache
fails to initialise and the page cache and swaps just go down their normal
non-zache/frontswap/cleancache paths.  The only time there is a difference
between GFP_ATOMIC and GFP_NOWAIT, AFAIK, is if there are no non-emergency pages
left, which is unlikely to be the case.

Plus, I don't want to have to send out v3 of a one line patch :-/

Thanks,
Seth
