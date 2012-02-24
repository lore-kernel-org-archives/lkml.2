Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2BXQMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:12:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50343 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab2BXQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:12:17 -0500
Date: Fri, 24 Feb 2012 16:13:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Danny Kukawka <dkukawka@suse.de>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] rose: check given MAC address, if invalid return
 -EADDRNOTAVAIL
Message-ID: <20120224161358.17df7421@pyramind.ukuu.org.uk>
In-Reply-To: <1330099282-4588-13-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
	<1330099282-4588-13-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 17:01:22 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Check if given address is valid in .ndo_set_mac_address/
> rose_set_mac_address(), if invalid return -EADDRNOTAVAIL as
> eth_mac_addr() already does if is_valid_ether_addr() fails.

This patch series looks wrong - you cannot go blindly applying ethernet
mac address tests to device drivers without checking if they are using
802.11 type addressing at the physical level.

Alan


