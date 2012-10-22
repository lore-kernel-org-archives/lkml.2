Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2JVP0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:26:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2JVP0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:26:12 -0400
Message-ID: <508565FA.4040908@redhat.com>
Date: Mon, 22 Oct 2012 11:27:54 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
CC: dri-devel@lists.freedesktop.org, Benjamin Herrenschmidt <benh@au1.ibm.com>,
        linux-pci@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: radeon: RFC speed cap detection on ppc64
References: <50819140.8030806@linux.vnet.ibm.com>
In-Reply-To: <50819140.8030806@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/12 1:43 PM, Lucas Kannebley Tavares wrote:
> The radeon driver does speed cap detection on the root PCI device for
> the maximum speed with which the adapter can communicate. On ppc64
> systems, however, the root device belongs to the Hypervisor, so the
> current code would case a null pointer dereference.
>
> I propose to look for the outmost bus with a parent node and get speed
> caps from it, though I suppose the cleaner way would be to inspect all
> devices along the way and choose the smallest speed cap.

That (walking all parent nodes) is probably the safest thing to do.  I'm 
not sure whether it's optimal.  It would likely depend on whether you 
can meaningfully have a bridge that's faster on the downstream side than 
on the upstream.

- ajax
