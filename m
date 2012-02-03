Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2BCOEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:04:46 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57872 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541Ab2BCOEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:04:44 -0500
MIME-Version: 1.0
In-Reply-To: <1328228079-20716-1-git-send-email-venki@google.com>
References: <1328227065-22045-1-git-send-email-venki@google.com>
	<1328228079-20716-1-git-send-email-venki@google.com>
Date: Fri, 3 Feb 2012 15:04:43 +0100
Message-ID: <CAN5iSWo-n7OER4i1tPoeGBhY_RY-nX=7n4B3mFv1f0JK074bhQ@mail.gmail.com>
Subject: Re: [PATCH] CPU C-state breakage with PM Qos change
From: "Pihet-XID, Jean" <j-pihet@ti.com>
To: Venkatesh Pallipadi <venki@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        markgross <markgross@thegnar.org>
Cc: Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looping in linux-pm

On Fri, Feb 3, 2012 at 1:14 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> Looks like change "PM QoS: Move and rename the implementation files"
> made pm_qos depend on CONFIG_PM which depends on
> PM_SLEEP || PM_RUNTIME
>
> That breaks CPU C-states with kernels not having these CONFIGs, causing CPUs
> to spend time in Polling loop idle instead of going into deep C-states,
> consuming way way more power. This is with either acpi idle or intel idle
> enabled.
>
> Either CONFIG_PM should be enabled with any pm_qos users or
> the !CONFIG_PM pm_qos_request() should return sane defaults not to break
> the existing users. Here's is the patch for the latter option.
I think the real question is whether PM QoS should be functional in
all cases (as is ACPI) or whether only if certain options are set
(CONFIG_PM).
In the current code if CONFIG_PM is not enabled, a dummy PM QoS API is
provided as function stubs in order for the build to succeed.

Rafael, Mark,
What do you think? Should PM QoS be enabled in all cases? Are there
any known dependencies with CONFIG_PM?

Regards,
Jean
