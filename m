Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1DGWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:23:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414Ab1DGWXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:23:17 -0400
Date: Thu, 7 Apr 2011 15:23:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH] PCI: Enable ASPM state clearing regardless of policy
Message-Id: <20110407152310.5bfeab8b.akpm@linux-foundation.org>
In-Reply-To: <20110310185351.3394.54996.stgit@s20.home>
References: <20110310185351.3394.54996.stgit@s20.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 11:54:16 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Commit 2f671e2d allowed us to clear ASPM state when the FADT
> tells us it isn't supported, but we don't put this into effect
> if the aspm_policy is set to POLICY_POWERSAVE.  Enable the
> state to be cleared regardless of policy.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/pci/pcie/aspm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 3188cd9..eb8ac5c 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -607,7 +607,7 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
>  	 * the BIOS's expectation, we'll do so once pci_enable_device() is
>  	 * called.
>  	 */
> -	if (aspm_policy != POLICY_POWERSAVE) {
> +	if (aspm_policy != POLICY_POWERSAVE || aspm_clear_state) {
>  		pcie_config_aspm_path(link);
>  		pcie_set_clkpm(link, policy_to_clkpm_state(link));
>  	}

hm.  why.  Presumably this change has some user-observeable effect.

What is that effect, and why is it desirable? ;)
