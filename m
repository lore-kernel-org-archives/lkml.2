Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab0DHTK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:10:59 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:48621 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab0DHTK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:10:57 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF/HvUurRN+K/2dsb2JhbACbOXGiGZkzhQkEgyQ
X-IronPort-AV: E=Sophos;i="4.52,172,1270425600"; 
   d="scan'208";a="112510569"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
	<1270753107-15881-5-git-send-email-yinghai@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 08 Apr 2010 12:10:53 -0700
In-Reply-To: <1270753107-15881-5-git-send-email-yinghai@kernel.org> (Yinghai
	Lu's message of "Thu, 8 Apr 2010 11:58:25 -0700")
Message-ID: <adawrwhwyiq.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +#ifdef CONFIG_PCI_IOV
 > +	if (dev->is_virtfn)
 > +		dev = dev->physfn;
 > +#endif

Seems we would prefer to avoid this ifdef... if we had a function like

	struct pci_dev *pci_physfn(struct pci_dev *virtfn)

as an inline in <linux/pci.h> that just returns NULL if PCI_IOV is not
enabled, then we could write this as

	if (dev->is_virtfn)
		dev = pci_physfn(dev)

without any #ifdef.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
