Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1GFP3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:29:24 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56654 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab1GFP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:29:23 -0400
X-Sasl-enc: CgbKrt+adsdPwB81REO81Y1HsHm5m2wHJMg3CM2ByGj3 1309966162
Date: Wed, 6 Jul 2011 08:29:16 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 15/77] Staging: hv: blkvsc: Add the appropriate
 MODULE_ALIAS() line
Message-ID: <20110706152916.GB30350@kroah.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-15-git-send-email-kys@microsoft.com>
 <20110705160621.GC7214@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D27E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110706034228.GA4291@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D414@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110706150202.GA3353@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D432@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816D432@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:17:37PM +0000, KY Srinivasan wrote:
> It is certainly easier to deal with a small integer than with 128bit giud and there is
> no added benefit dealing with guids since the number of drivers we will support
> under vmbus will never exceed a very small number. Having said that, I will go ahead
> and embed full guids as you have suggested. So, the aliases for these drivers will be:
> vmbus:device guid.

Wait, no, you will never be typing "MODULE_ALIAS()" in your driver at
all, it will be created automatically for you by the proper macro fun
with the MODULE_DEVICE_TABLE() line.  The same variable you use in that
macro will be used to register the driver with the vmbus core.

No one ever sees module aliases in the "raw" anymore, except for the
platform legacy crud.

thanks,

greg k-h
