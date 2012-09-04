Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2IDXBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:01:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2IDXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:01:50 -0400
Date: Tue, 4 Sep 2012 15:59:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, ben@decadent.org.uk, thozza@redhat.com,
        dcbw@redhat.com
Subject: Re: [PATCH V4 05/10] Tools: hv: Add an example script to retrieve
 dhcp state
Message-ID: <20120904225917.GB3725@kroah.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-5-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346795202-25655-5-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:46:37PM -0700, K. Y. Srinivasan wrote:
> To keep the KVP daemon code free of distro specific details, we invoke an
> external script to retrieve the DHCP state. This is an example script that
> was used to test the KVP code. This script has to be implemented in a Distro
> specific fashion. For instance on distros that ship with Network Manager enabled,
> this script can be based on NM APIs.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  tools/hv/hv_get_dhcp_info.sh |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100755 tools/hv/hv_get_dhcp_info.sh
> 
> diff --git a/tools/hv/hv_get_dhcp_info.sh b/tools/hv/hv_get_dhcp_info.sh
> new file mode 100755
> index 0000000..3de4587
> --- /dev/null
> +++ b/tools/hv/hv_get_dhcp_info.sh
> @@ -0,0 +1,25 @@
> +#!/bin/bash
> +
> +# This example script retrieves the DHCP state of a given interface.
> +# In the interest of keeping the KVP daemon code free of distro specific
> +# information; the kvp daemon code invokes this external script to gather
> +# DHCP setting for the specific interface.
> +#
> +# Input: Name of the interface
> +#
> +# Output: The script prints the string "Enabled" to stdout to indicate
> +#	that DHCP is enabled on the interface.

What happens if DHCP is not enabled on the interface?  Shouldn't that
also return something other than "success"?

greg k-h
