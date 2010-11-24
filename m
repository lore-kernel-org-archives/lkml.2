Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0KXGtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:49:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62479 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0KXGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rzFwPmPBGqirxHDwj58HsGdoAIiPlul8gq0hCWFIl+Uh888s1al70I3/WmW4RqBcjw
         BL2nmj95SdZswnj92GWmKuPoTtttostRXLBS9xQC6JvA/YUUe0JZUANfKVSWiCxZemh0
         kkpSuy0YhShT9o/eUW9HlwWq/uTHVZJk/b9LI=
Date: Wed, 24 Nov 2010 09:46:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: arcfb: fix buffer overflow
Message-ID: <20101124064649.GQ1522@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Vasiliy Kulikov <segoon@openwall.com>,
	kernel-janitors@vger.kernel.org, Jaya Kumar <jayalk@intworks.biz>,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1290361202-15065-1-git-send-email-segoon@openwall.com>
 <20101124062558.GF11705@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101124062558.GF11705@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 03:25:58PM +0900, Paul Mundt wrote:
> On Sun, Nov 21, 2010 at 08:40:01PM +0300, Vasiliy Kulikov wrote:
> > (count + p) is not checked for integer overflow.  If p < fbmemlength
> > and count == (size_t)(1 - p) (very big unsigned integer) then
> > count + p == 1 < fbmemlength and copy_to_user(base_addr+p, buf, count)
> > overflows base_addr.
> > 
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> 
> Applied, thanks.

The patch is harmless, but the integer overflow would actually be caught
in rw_verify_area().

regards,
dan carpenter

