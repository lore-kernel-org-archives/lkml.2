Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2GXXiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:38:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45117 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914Ab2GXXiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:38:20 -0400
Date: Wed, 25 Jul 2012 00:38:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org
Message-ID: <20120724233809.GC1894@decadent.org.uk>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-11-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343145701-3691-11-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 11/17] Tools: hv: Gather DNS information
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:01:35AM -0700, K. Y. Srinivasan wrote:
> Now gather DNS information. This information cannot be gathered in
> a distro independent fashion. Invoke an external script (that can be
> distro dependent) to gather the DNS information.
[...]
> +	memset(cmd, 0, sizeof(cmd));
> +	strcat(cmd, "/sbin/hv_get_dns_info ");
> +	strcat(cmd, if_name);
[...]

This is a weird way to build a string; why are you not using
snprintf()?  Not to mention that interface names can contain several
characters that are special to the shell - in fact the only disallowed
characters are / and whitespace.
 
Also, the external script will not be useful to anything other than
hv_kvp_daemon, so it probably belongs somewhere under /usr/share.
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
