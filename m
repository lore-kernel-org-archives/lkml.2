Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2F1OXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:23:45 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:52926 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2F1OXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:23:43 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIiS0MFWc=
X-RZG-CLASS-ID: mo00
Date: Thu, 28 Jun 2012 16:23:40 +0200
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, apw@canonical.com,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] drivers: hv: kvp
Message-ID: <20120628142340.GA21537@aepfle.de>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <20120621224737.GA5933@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155EC47A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120622132547.GA2639@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED14D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626213954.GA4840@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED64A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626222205.GA5948@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, KY Srinivasan wrote:

> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > The fact that it was Red Hat specific was the main part, this should be
> > done in a standard way, with standard tools, right?
> 
> The reason I asked this question was to make sure I address these
> issues in addition to whatever I am debugging now. I use the standard
> tools and calls to retrieve all the IP configuration. As I look at
> each distribution the files they keep persistent IP configuration
> Information is different and that is the reason I chose to start with
> RedHat. If there is a standard way to store the configuration, I will
> do that.


KY,

instead of using system() in kvp_get_ipconfig_info and kvp_set_ip_info,
wouldnt it be easier to call an external helper script which does all
the distribution specific work? Just define some API to pass values to
the script, and something to read values collected by the script back
into the daemon.

If the work is done in a script it will be much easier for an admin to
debug and adjust it.

I think there is no standard way to configure all relevant distros in
the same way. Maybe one day NetworkManager can finally handle all
possible ways to configure network related things. But until that
happens the config files need to be adjusted manually.



Some of the functions have deep indention levels due to 'while() {
switch() }' usage. Perhaps such code could be moved into its own
function so that lines dont need to be wrapped that much due to the odd
80 column limit.

Olaf
