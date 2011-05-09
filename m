Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1EIUog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:44:36 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45182 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754764Ab1EIUod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:44:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=s0LgZ1Ad9gr309I6mMofISaCjCTnlrF4QlwS2vhzrpOPlmrUZkLtEfVz0dTzjwX+C0tDcvZ+CsqFfZrtCjPivqInAZxj6UJgn2tx780xtPrP3YfM7NdXfeSHInSj83Vs;
Date: Mon, 9 May 2011 13:43:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v3 1/3] PCI: Track the size of each saved capability
 data area
Message-ID: <20110509134356.63f66a29@jbarnes-desktop>
In-Reply-To: <20110420203133.3189.22786.stgit@s20.home>
References: <20110420202523.3189.31306.stgit@s20.home>
	<20110420203133.3189.22786.stgit@s20.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 14:31:33 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> -struct pci_cap_saved_state {
> -	struct hlist_node next;
> +struct pci_cap_saved {
>  	char cap_nr;
> +	unsigned int size;
>  	u32 data[0];
>  };
>  
> +struct pci_cap_saved_state {
> +	struct hlist_node next;
> +	struct pci_cap_saved saved;
> +};
> +
>  struct pcie_link_state;
>  struct pci_vpd;
>  struct pci_sriov;
> @@ -366,7 +371,7 @@ static inline struct pci_cap_saved_state *pci_find_saved_cap(
>  	struct hlist_node *pos;
>  
>  	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
> -		if (tmp->cap_nr == cap)
> +		if (tmp->saved.cap_nr == cap)
>  			return tmp;
>  	}
>  	return NULL;

Looks pretty good in general.  But I think the naming makes it harder
to read than it ought to be.

So we have a pci_cap_saved_state, which implies capability info, and
that's fine.

But pci_cap_saved doesn't communicate much; maybe pci_cap_data or
pci_cap_saved_data would be better?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
