Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2KTOZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:25:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29417 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KTOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:25:17 -0500
Date: Tue, 20 Nov 2012 17:25:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: MAACHE Mehdi <mehdi.maache@gmail.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: Re: [PATCH] Staging: rtl8187se: fixed some checkpatch warnings and
 errors in r8180_wx.c
Message-ID: <20121120142504.GC11248@mwanda>
References: <1353418002-8254-1-git-send-email-mehdi.maache@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353418002-8254-1-git-send-email-mehdi.maache@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:26:42PM +0100, MAACHE Mehdi wrote:
> This is a patch to the r8180_wx.c file that fixes up some warnings and errors found by the checkpatch.pl tool
> - WARNING: line over 80 characters
> - ERROR: "(foo*)" should be "(foo *)"
> - ERROR: "foo* bar" should be "foo *bar"
> - ERROR: trailing whitespace
> - ERROR: that open brace { should be on the previous line
>

This needs to be broken into 4-5 separate patches and sent as
series.  One patch per warning type.

> -	if (erq->flags & IW_ENCODE_DISABLED)
> -
> -	if (erq->length > 0) {
> -		u32* tkey = (u32*) key;
> +	if ((erq->flags & IW_ENCODE_DISABLED) && erq->length > 0) {
> +		u32 *tkey = (u32 *) key;

Interesting...  You have preserved the meaning of the original code,
but actually the original code is buggy.  Just delete the
"if (erq->flags & IW_ENCODE_DISABLED)" check.  This bug was
introduced in de171bd6ff "Staging: rtl8187se: r8180_wx: fixed a lot
of checkptahc.pl issues".

Send that as a separate patch and mark it as a bugfix.

regards,
dan carpenter

