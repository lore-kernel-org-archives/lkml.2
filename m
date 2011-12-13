Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1LMHpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:45:31 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:49379 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1LMHp2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:2>);
	Tue, 13 Dec 2011 02:45:28 -0500
Message-Id: <4EE710A00200007800067274@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 13 Dec 2011 07:45:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <stefan.bader@canonical.com>, <Ian.Campbell@citrix.com>,
        <mike.mcclurg@citrix.com>, <jeremy@goop.org>, <ke.yu@intel.com>,
        <kevin.tian@intel.com>, <konrad@kernel.org>, <lenb@kernel.org>,
        <xen-devel@lists.xensource.com>, <liang.tang@oracle.com>,
        <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 5/8] ACPI: add processor driver for Xen
 virtual CPUs.
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
 <4ED755D70200007800064987@nat28.tlf.novell.com>
 <20111212172941.GA8619@phenom.dumpdata.com>
In-Reply-To: <20111212172941.GA8619@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.12.11 at 18:29, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Thu, Dec 01, 2011 at 09:24:23AM +0000, Jan Beulich wrote:
>> >>> On 30.11.11 at 18:21, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > --- a/drivers/acpi/Makefile
>> > +++ b/drivers/acpi/Makefile
>> > @@ -66,6 +66,7 @@ obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
>> >  # processor has its own "processor." module_param namespace
>> >  processor-y			:= processor_driver.o processor_throttling.o
>> >  processor-y			+= processor_idle.o processor_thermal.o
>> > +processor-y			+= processor_xen.o
>> 
>> This should minimally be processor-$(CONFIG_XEN), with other things
>> adjusted as necessary.
> 
> I was under the impression that this was required to get the 
> processor_xen.ko
> to be a module. Otherwise it would only compile as built-in.

processor_xen.ko? Why not have all the code go into processor.ko?
(And the original construct didn't aim in that direction either.)

Jan

