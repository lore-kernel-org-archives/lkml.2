Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab2EIOQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:16:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33471 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422Ab2EIOQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:16:11 -0400
Date: Wed, 9 May 2012 17:19:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Message-ID: <20120509141920.GT22134@mwanda>
References: <201205081641.00358.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
 <4FAA44D7.1040209@mev.co.uk>
 <20120509103111.GR22134@mwanda>
 <4FAA4E85.6020305@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA4E85.6020305@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 12:01:25PM +0100, Ian Abbott wrote:
> Are there any handy macros for casting pointers to __user pointers,
> something like
> 
> #define _user(p) ((typeof(*(p)) __user *)(p))
> 
> but preferably without the repeated expansion of 'p' in case of
> side-effects?

typeof() doesn't have side effects.

#include <stdio.h>

int main(void)
{
	int x = 0;
	typeof(x++) y;

	printf("%d\n", x);

	return 0;
}

regards,
dan carpenter
