Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1IGQKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:10:40 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54700 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1IGQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:10:38 -0400
Date: Wed, 7 Sep 2011 12:50:11 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 03/10] fadump: Register for firmware assisted dump.
Message-ID: <20110907072011.GA19226@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
 <20110713180705.6210.44160.stgit@mars.in.ibm.com>
 <20110831142049.5e8270b9@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831142049.5e8270b9@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11090707-3568-0000-0000-0000003C7AF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On 2011-08-31 14:20:49 Wed, Anton Blanchard wrote:
> 
> Hi,
> 
> > +static void fadump_show_config(void)
> > +{
> > +	DBG("Support for firmware-assisted dump (fadump): %s\n",
> > +			(fw_dump.fadump_supported ? "present" : "no support"));
> > +
> > +	if (!fw_dump.fadump_supported)
> > +		return;
> > +
> > +	DBG("Fadump enabled    : %s\n",
> > +				(fw_dump.fadump_enabled ? "yes" : "no"));
> > +	DBG("Dump Active       : %s\n", (fw_dump.dump_active ? "yes" : "no"));
> > +	DBG("Dump section sizes:\n");
> > +	DBG("	CPU state data size: %lx\n", fw_dump.cpu_state_data_size);
> > +	DBG("	HPTE region size   : %lx\n", fw_dump.hpte_region_size);
> > +	DBG("Boot memory size  : %lx\n", fw_dump.boot_memory_size);
> > +	DBG("Reserve area start: %lx\n", fw_dump.reserve_dump_area_start);
> > +	DBG("Reserve area size : %lx\n", fw_dump.reserve_dump_area_size);
> > +}
> > +
> > +static void show_fadump_mem_struct(const struct fadump_mem_struct *fdm)
> > +{
> > +	if (!fdm)
> > +		return;
> > +
> > +	DBG("--------Firmware-assisted dump memory structure---------\n");
> > +	DBG("header.dump_format_version        : 0x%08x\n",
> > +					fdm->header.dump_format_version);
> > +	DBG("header.dump_num_sections          : %d\n",
> > +					fdm->header.dump_num_sections);
> > +	DBG("header.dump_status_flag           : 0x%04x\n",
> > +					fdm->header.dump_status_flag);
> > +	DBG("header.offset_first_dump_section  : 0x%x\n",
> > +					fdm->header.offset_first_dump_section);
> > +
> > +	DBG("header.dd_block_size              : %d\n",
> > +					fdm->header.dd_block_size);
> > +	DBG("header.dd_block_offset            : 0x%Lx\n",
> > +					fdm->header.dd_block_offset);
> > +	DBG("header.dd_num_blocks              : %Lx\n",
> > +					fdm->header.dd_num_blocks);
> > +	DBG("header.dd_offset_disk_path        : 0x%x\n",
> > +					fdm->header.dd_offset_disk_path);
> > +
> > +	DBG("header.max_time_auto              : %d\n",
> > +					fdm->header.max_time_auto);
> > +
> > +	/* Kernel dump sections */
> > +	DBG("cpu_state_data.request_flag       : 0x%08x\n",
> > +					fdm->cpu_state_data.request_flag);
> > +	DBG("cpu_state_data.source_data_type   : 0x%04x\n",
> > +					fdm->cpu_state_data.source_data_type);
> > +	DBG("cpu_state_data.error_flags        : 0x%04x\n",
> > +					fdm->cpu_state_data.error_flags);
> > +	DBG("cpu_state_data.source_address     : 0x%016Lx\n",
> > +					fdm->cpu_state_data.source_address);
> > +	DBG("cpu_state_data.source_len         : 0x%Lx\n",
> > +					fdm->cpu_state_data.source_len);
> > +	DBG("cpu_state_data.bytes_dumped       : 0x%Lx\n",
> > +					fdm->cpu_state_data.bytes_dumped);
> > +	DBG("cpu_state_data.destination_address: 0x%016Lx\n",
> > +				fdm->cpu_state_data.destination_address);
> > +
> > +	DBG("hpte_region.request_flag          : 0x%08x\n",
> > +					fdm->hpte_region.request_flag);
> > +	DBG("hpte_region.source_data_type      : 0x%04x\n",
> > +					fdm->hpte_region.source_data_type);
> > +	DBG("hpte_region.error_flags           : 0x%04x\n",
> > +					fdm->hpte_region.error_flags);
> > +	DBG("hpte_region.source_address        : 0x%016Lx\n",
> > +					fdm->hpte_region.source_address);
> > +	DBG("hpte_region.source_len            : 0x%Lx\n",
> > +					fdm->hpte_region.source_len);
> > +	DBG("hpte_region.bytes_dumped          : 0x%Lx\n",
> > +					fdm->hpte_region.bytes_dumped);
> > +	DBG("hpte_region.destination_address   : 0x%016Lx\n",
> > +				fdm->hpte_region.destination_address);
> > +
> > +	DBG("rmr_region.request_flag           : 0x%08x\n",
> > +					fdm->rmr_region.request_flag);
> > +	DBG("rmr_region.source_data_type       : 0x%04x\n",
> > +					fdm->rmr_region.source_data_type);
> > +	DBG("rmr_region.error_flags            : 0x%04x\n",
> > +					fdm->rmr_region.error_flags);
> > +	DBG("rmr_region.source_address         : 0x%016Lx\n",
> > +					fdm->rmr_region.source_address);
> > +	DBG("rmr_region.source_len             : 0x%Lx\n",
> > +					fdm->rmr_region.source_len);
> > +	DBG("rmr_region.bytes_dumped           : 0x%Lx\n",
> > +					fdm->rmr_region.bytes_dumped);
> > +	DBG("rmr_region.destination_address    : 0x%016Lx\n",
> > +				fdm->rmr_region.destination_address);
> > +
> > +	DBG("--------Firmware-assisted dump memory structure---------\n");
> > +}
> > +
> 
> That's an awful lot of debug information. I don't think we need to carry
> this around in the kernel once the feature is working.

Sure, will remove them.

> 
> > +static ssize_t fadump_enabled_show(struct kobject *kobj,
> > +					struct kobj_attribute *attr,
> > +					char *buf)
> > +{
> > +	return sprintf(buf, "%d\n", fw_dump.fadump_enabled);
> > +}
> > +
> 
> > +static ssize_t fadump_region_show(struct kobject *kobj,
> > +					struct kobj_attribute *attr,
> > +					char *buf)
> > +{
> > +	const struct fadump_mem_struct *fdm_ptr;
> > +	ssize_t n = 0;
> > +
> > +	if (!fw_dump.fadump_enabled)
> > +		return n;
> > +
> > +	if (fdm_active)
> > +		fdm_ptr = fdm_active;
> > +	else
> > +		fdm_ptr = &fdm;
> > +
> > +	n += sprintf(buf,
> > +			"CPU : [%#016llx-%#016llx] %#llx bytes, "
> > +			"Dumped: %#llx\n",
> > +			fdm_ptr->cpu_state_data.destination_address,
> > +			fdm_ptr->cpu_state_data.destination_address +
> > +			fdm_ptr->cpu_state_data.source_len - 1,
> > +			fdm_ptr->cpu_state_data.source_len,
> > +			fdm_ptr->cpu_state_data.bytes_dumped);
> > +	n += sprintf(buf + n,
> > +			"HPTE: [%#016llx-%#016llx] %#llx bytes, "
> > +			"Dumped: %#llx\n",
> > +			fdm_ptr->hpte_region.destination_address,
> > +			fdm_ptr->hpte_region.destination_address +
> > +			fdm_ptr->hpte_region.source_len - 1,
> > +			fdm_ptr->hpte_region.source_len,
> > +			fdm_ptr->hpte_region.bytes_dumped);
> > +	n += sprintf(buf + n,
> > +			"DUMP: [%#016llx-%#016llx] %#llx bytes, "
> > +			"Dumped: %#llx\n",
> > +			fdm_ptr->rmr_region.destination_address,
> > +			fdm_ptr->rmr_region.destination_address +
> > +			fdm_ptr->rmr_region.source_len - 1,
> > +			fdm_ptr->rmr_region.source_len,
> > +			fdm_ptr->rmr_region.bytes_dumped);
> > +
> > +	if (!fdm_active ||
> > +		(fw_dump.reserve_dump_area_start ==
> > +		fdm_ptr->cpu_state_data.destination_address))
> > +		return n;
> > +
> > +	/* Dump is active. Show reserved memory region. */
> > +	n += sprintf(buf + n,
> > +			"    : [%#016llx-%#016llx] %#llx bytes, "
> > +			"Dumped: %#llx\n",
> > +			(unsigned long long)fw_dump.reserve_dump_area_start,
> > +			fdm_ptr->cpu_state_data.destination_address - 1,
> > +			fdm_ptr->cpu_state_data.destination_address -
> > +			fw_dump.reserve_dump_area_start,
> > +			fdm_ptr->cpu_state_data.destination_address -
> > +			fw_dump.reserve_dump_area_start);
> > +	return n;
> > +}
> > +
> > +static struct kobj_attribute fadump_attr = __ATTR(fadump_enabled,
> > +						0444, fadump_enabled_show,
> > +						NULL);
> > +static struct kobj_attribute fadump_region_attr = __ATTR(fadump_region,
> > +						0444, fadump_region_show, NULL);
> > +
> > +static int fadump_init_sysfs(void)
> > +{
> > +	int rc = 0;
> > +
> > +	rc = sysfs_create_file(kernel_kobj, &fadump_attr.attr);
> > +	if (rc)
> > +		printk(KERN_ERR "fadump: unable to create sysfs file"
> > +			" (%d)\n", rc);
> > +
> > +	rc = sysfs_create_file(kernel_kobj, &fadump_region_attr.attr);
> > +	if (rc)
> > +		printk(KERN_ERR "fadump: unable to create sysfs file"
> > +			" (%d)\n", rc);
> > +	return rc;
> > +}
> > +subsys_initcall(fadump_init_sysfs);
> 
> Do we need to dump this all out via sysfs? Will tools depend on this,
> or is it just for debug? It might be better to place in debugfs.

The 'fadump_enabled' sysfs attribute will be used by tool (e.g. kdump
init script) to find out whether fadump is enabled or not and act accordingly.
I will place 'fadump_region' under debugfs as it only shows the fadump memory
reservation map information.

Thanks,
-Mahesh.

-- 
Mahesh J Salgaonkar

