Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0KHEiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 23:38:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41548 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0KHEiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 23:38:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=eQGkWLPR65HU8A+KDs3SaQK5u24/9yX7IAIdpscz7LYn2k+n4pgKTOREKAyKFR43O9
         ZTmhhxNdhTHSGiD/FE7lL1NWOAxlCuhXq4SJBywlR5UnMR9K9vjknTUYbWtZt4T7tbDC
         sSnF8Op3UsOcXLeLjnRWzMTnSVAE1Sc6nUMjI=
Date: Mon, 8 Nov 2010 06:37:52 +0200
From: Dan Carpenter <error27@gmail.com>
To: =?utf-8?B?5r2Y5Y2r5bmzKFBldGVyIFBhbik=?= <wppan@redflag-linux.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4:memset is needless in ext4_ext_remove_space()
Message-ID: <20101108043752.GB5563@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	=?utf-8?B?5r2Y5Y2r5bmzKFBldGVyIFBhbik=?= <wppan@redflag-linux.com>,
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4CD75033.7080902@redflag-linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CD75033.7080902@redflag-linux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:19:47AM +0800, "潘卫平(Peter Pan)" wrote:
>
> memset is needless because path is allocated by kzalloc.
>

This is inside a loop and sometimes we do i++ and sometimes i--.  Are
you absolutely positive that path + i isn't initialized?

I haven't followed this code through all the way but my instinct is
that the memset is there for a reason.

regards,
dan carpenter


