Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2JWFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:47:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47771 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2JWFrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:47:37 -0400
Date: Tue, 23 Oct 2012 08:47:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: 3.7 RC1
Message-ID: <20121023054716.GA20120@mwanda>
References: <1350949065-24655-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350949065-24655-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 04:37:45PM -0700, K. Y. Srinivasan wrote:
> 
> While testing 3.7 RC1 I discovered that invoking the function orderly_poweroff()
> from an interrupt context will trigger an ASSERT(). This was not the case till
> recently. The comment preceding the orderly_poweroff() function claims that this
> function can be invoked from any context and in the current Hyper-V util driver,
> we support host-driven orderly shut down of the guest by invoking this
> orderly_poweroff() function in the context of the message callback. This code has
> been working for a very long time and it is broken now. Is my assumption that
> orderly_poweroff() could be invoked from the interrupt context a wrong assumption?

You can't call orderly_poweroff() from interrupt context.

regards,
dan carpenter
