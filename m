Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1BQWYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:24:25 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:51344 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019Ab1BQWYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:24:23 -0500
Message-ID: <4D5DA038.5070505@bluewatersys.com>
Date: Fri, 18 Feb 2011 11:24:56 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Charles Manning <cdhmanning@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 09/10] Add yaffs2 file system: Linux glue code
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <1297221968-6747-10-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1297221968-6747-10-git-send-email-cdhmanning@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 04:26 PM, Charles Manning wrote:
> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---

<snip>

> +/*
> + * yaffs_search_end() disposes of a search context and cleans up.
> + */
> +static void yaffs_search_end(struct yaffs_search_context *sc)
> +{
> +	if (sc) {

This test, and the similar one in yaffs_search_advance, are not needed.
There is no way that sc can be passed as NULL here. Even if that could
happen you probably want to oops rather than silently carrying on.

I think there are similar issues in other functions throughout the yaffs
code where you are testing if various pointers are NULL and returning
silently if they are. All of these cases should be fixed to remove the
extraneous code.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
