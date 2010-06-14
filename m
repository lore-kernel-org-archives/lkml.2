Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab0FONow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:44:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29242 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab0FONou (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Jun 2010 09:44:50 -0400
Date: Mon, 14 Jun 2010 17:20:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, ddutile@redhat.com,
       sheng@linux.intel.com
Subject: Re: [Xen-devel] [PATCH 03/12] evtchn delivery on HVM
Message-ID: <20100614212040.GC8600@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1275570645-27189-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275570645-27189-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4C1783CB.00DB:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
> +				    unsigned long action, void *hcpu)
> +{
> +	int cpu = (long)hcpu;
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
> +		break;

Is there no need to do anything if the CPUs are brought down?

.. snip..

> +/* the callback vector mechanism is a newer alternative way of receiving
> + * event channel notifications from Xen: we can receive vector callbacks
> + * on any vcpus and we don't need any PCI or IO APIC support */

I am not an expert in English, but I think you need to revise this
comment.
> +void xen_callback_vector(void)
> +{
> +	int rc;
> +	uint64_t callback_via;
> +	if (xen_have_vector_callback) {
> +		callback_via = HVM_CALLBACK_VECTOR(XEN_HVM_EVTCHN_CALLBACK);
> +		rc = xen_set_callback_via(callback_via);
> +		if (rc) {
> +			printk(KERN_ERR "request for callback vector failed\n");

Perhaps mention which type? Say 'Request for Xen HVM callback vector
failed.\n' ?
