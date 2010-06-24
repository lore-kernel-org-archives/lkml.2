Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0FXWF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 18:05:28 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:44163 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0FXWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 18:05:26 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAONzI0yrR7H+/2dsb2JhbACfOnGoCJpFhSEEg14
X-IronPort-AV: E=Sophos;i="4.53,476,1272844800"; 
   d="scan'208";a="149484083"
From: Roland Dreier <rdreier@cisco.com>
To: Kurt Newman <knewman@globaldataguard.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32.1 kernel unable to use more than 2 of 16 CPUs on Intel E5540 (i7)
References: <4C23D1E9.9050007@globaldataguard.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Jun 2010 15:05:22 -0700
In-Reply-To: <4C23D1E9.9050007@globaldataguard.com> (Kurt Newman's message of
	"Thu, 24 Jun 2010 16:45:13 -0500")
Message-ID: <adahbksqe71.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your config seems to have CONFIG_PM and therefore CONFIG_ACPI disabled.
So the kernel is relying on mptable information.  Unsurprisingly on a
modern system, that info is probably broken -- since everything would
have been tested with ACPI.

Try turning on CONFIG_ACPI and see if that helps at all.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
