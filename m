Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1FUHXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:23:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38094 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1FUHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:23:05 -0400
Date: Tue, 21 Jun 2011 09:23:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: Re: [PATCH 1/4] ACPI, APEI, GHES, Prevent GHES to be built as module
Message-ID: <20110621072301.GA3263@one.firstfloor.org>
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com> <1308640587-24502-2-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308640587-24502-2-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 03:16:24PM +0800, Huang Ying wrote:
> GHES (Generic Hardware Error Source) is used to process hardware error
> notification in firmware first mode.  But because firmware first mode
> can be turned on but can not be turned off, it is unreasonable to
> unload the GHES module with firmware first mode turned on.  To avoid
> confusion, this patch makes GHES can be enable/disable in
> configuration time, but not built as module and unload at run time.

It's better to keep it as a module, but disable unloading.
You can do that with a __module_get(THIS_MODULE) in the init code
when FFM is detected.

-Andi
