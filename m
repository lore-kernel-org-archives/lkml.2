Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab1DHTuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:50:22 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39306 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757777Ab1DHTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:50:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WiYagT2n5cLBMiEVc07+4L7z9lEaPBTK8svcxoGIz8RE3aE+yIsCNlqzOQZhG2tEnzFF8AfWgWt5sHcCVW5KD4Mbkf/H8N5YM2YvrspWj+9jccDSx6g22sypOJecKaw9;
Date: Fri, 8 Apr 2011 12:50:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH] PCI: Enable ASPM state clearing regardless of policy
Message-ID: <20110408125010.76ab64e1@jbarnes-desktop>
In-Reply-To: <20110310185351.3394.54996.stgit@s20.home>
References: <20110310185351.3394.54996.stgit@s20.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
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
> 
> 

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
