Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0FHQJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:09:38 -0400
Received: from claw.goop.org ([74.207.240.146]:37590 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0FHQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:09:36 -0400
Message-ID: <4C0E6B3F.3080404@goop.org>
Date: Tue, 08 Jun 2010 09:09:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 02/12] early PV on HVM
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com> <20100604202008.GB17645@phenom.dumpdata.com> <alpine.DEB.2.00.1006071518050.3401@kaball-desktop> <20100608134637.GA5998@phenom.dumpdata.com>
In-Reply-To: <20100608134637.GA5998@phenom.dumpdata.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 06:46 AM, Konrad Rzeszutek Wilk wrote:
>>>> +	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
>>>>         
>>>       
> So.. what is the purpose of the per_cpu(xen_vcpu, 0) then?
>   

We still need the percpu info for things like time, but it is mapped out
of the platform device rather than placed at any address we want in
kernel memory (vcpu info placement), where we can access it directly as
a percpu variable.  This is only really relevent for the implementation
of the interrupt enable/disable pvops, so it doesn't matter for hvm.

    J
