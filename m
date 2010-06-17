Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0FQPn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:43:58 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:63357 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab0FQPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:43:57 -0400
X-IronPort-AV: E=Sophos;i="4.53,432,1272844800"; 
   d="scan'208";a="462488"
Date: Thu, 17 Jun 2010 16:41:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 03/12] evtchn delivery on HVM
In-Reply-To: <20100614212040.GC8600@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006171558570.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-3-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212040.GC8600@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > +static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
> > +				    unsigned long action, void *hcpu)
> > +{
> > +	int cpu = (long)hcpu;
> > +	switch (action) {
> > +	case CPU_UP_PREPARE:
> > +		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
> > +		break;
> 
> Is there no need to do anything if the CPUs are brought down?
> 

nope


> > +/* the callback vector mechanism is a newer alternative way of receiving
> > + * event channel notifications from Xen: we can receive vector callbacks
> > + * on any vcpus and we don't need any PCI or IO APIC support */
> 
> I am not an expert in English, but I think you need to revise this
> comment.


/* vector callbacks are better than PCI interrupts to receive event
 * channel notifications because we can receive vector callbacks on any
 * vcpu and we don't need PCI support or APIC interactions */

is it good enough?


> > +void xen_callback_vector(void)
> > +{
> > +	int rc;
> > +	uint64_t callback_via;
> > +	if (xen_have_vector_callback) {
> > +		callback_via = HVM_CALLBACK_VECTOR(XEN_HVM_EVTCHN_CALLBACK);
> > +		rc = xen_set_callback_via(callback_via);
> > +		if (rc) {
> > +			printk(KERN_ERR "request for callback vector failed\n");
> 
> Perhaps mention which type? Say 'Request for Xen HVM callback vector
> failed.\n' ?
> 

good idea, I'll do that
