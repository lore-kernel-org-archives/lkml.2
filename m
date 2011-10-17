Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1JQWYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:24:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38786 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab1JQWYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:24:46 -0400
Message-ID: <4E9CAB21.2020302@oracle.com>
Date: Mon, 17 Oct 2011 15:24:33 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] pci: Make sriov work with hotplug removal
References: <4E9A3092.4080309@oracle.com> <4E9A3408.9080905@oracle.com> <CAErSpo5XdM+1OFmoU+rN_QNWCJ0Wzv1VwKxsTo9hTq=2=7KEHA@mail.gmail.com> <4E9C6F0E.40501@oracle.com> <CAErSpo7ofdVixyGR74_mc6ND5C3LROiR9PVzwNZaDe23ptJ2=Q@mail.gmail.com>
In-Reply-To: <CAErSpo7ofdVixyGR74_mc6ND5C3LROiR9PVzwNZaDe23ptJ2=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4E9CAB2D.0004,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 03:12 PM, Bjorn Helgaas wrote:

> 
> Maybe this is the best we can do, but it still doesn't seem ideal, and
> it's certainly not obvious when reading the code.  It doesn't seem
> right for the driver ->remove() method to be calling
> pci_destroy_dev().   Won't the core data structures be corrupted if a
> defective driver doesn't call pci_disable_sriov()?  Seems like we
> could end up with a device that's been physically removed, but still
> has pci_dev structs hanging around.


i did add some print out in
	pci_stop_bus_device
when stop PF, that function is called for those VFs.

also driver have to call pci_disable_sriov() and that is current design.

Yinghai
