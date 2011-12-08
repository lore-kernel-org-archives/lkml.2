Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1LHTL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:11:26 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52301 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1LHTLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:11:24 -0500
Subject: [linux-3.2-rc4 PPC64] Series of "Section Mismatch" warnings, are
	they expected ?
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Manas k Nayak <maknayak@in.ibm.com>,
        Mark Wizner <markwiz@us.ibm.com>, Pavaman <pavsubra@in.ibm.com>,
        Naveed <naveedaus@in.ibm.com>, "divya.vikas" <divya.vikas@in.ibm.com>,
        Vishu <svishuku@in.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Fri, 09 Dec 2011 00:40:32 +0530
Message-Id: <1323371433.23534.8.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
x-cbid: 11120819-5806-0000-0000-0000105EDDFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While compiling linux-3.2-rc4 on PPC64, i get the following set of
warning series. I wanted to know if they are expected, or, they need to
be fixed:

LD      arch/powerpc/sysdev/xics/built-in.o
WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x136c): Section
mismatch in reference from the function .ics_rtas_init() to the
function .init.text:.xics_register_ics()
The function .ics_rtas_init() references
the function __init .xics_register_ics().
This is often because .ics_rtas_init lacks a __init 
annotation or the annotation of .xics_register_ics is wrong.

LD      arch/powerpc/sysdev/built-in.o
WARNING: arch/powerpc/sysdev/built-in.o(.text+0x99d4): Section mismatch
in reference from the function .ics_rtas_init() to the
function .init.text:.xics_register_ics()
The function .ics_rtas_init() references
the function __init .xics_register_ics().
This is often because .ics_rtas_init lacks a __init 
annotation or the annotation of .xics_register_ics is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x29914): Section mismatch
in reference from the function .prom_query_opal() to the
function .init.text:.call_prom()
The function .prom_query_opal() references
the function __init .call_prom().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .call_prom is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x2993c): Section mismatch
in reference from the function .prom_query_opal() to the
function .init.text:.call_prom()
The function .prom_query_opal() references
the function __init .call_prom().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .call_prom is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x2994c): Section mismatch
in reference from the function .prom_query_opal() to the
function .init.text:.prom_printf()
The function .prom_query_opal() references
the function __init .prom_printf().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x299a8): Section mismatch
in reference from the function .prom_query_opal() to the
function .init.text:.prom_printf()
The function .prom_query_opal() references
the function __init .prom_printf().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x299cc): Section mismatch
in reference from the function .prom_query_opal() to the
function .init.text:.prom_printf()
The function .prom_query_opal() references
the function __init .prom_printf().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x29d00): Section mismatch
in reference from the function .prom_opal_takeover() to the
function .init.text:.prom_printf()
The function .prom_opal_takeover() references
the function __init .prom_printf().
This is often because .prom_opal_takeover lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x29d04): Section mismatch
in reference from the function .prom_opal_takeover() to the
function .init.text:.prom_close_stdin()
The function .prom_opal_takeover() references
the function __init .prom_close_stdin().
This is often because .prom_opal_takeover lacks a __init 
annotation or the annotation of .prom_close_stdin is wrong.

MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x90be): Section mismatch in reference from the
variable generic_secondary_common_init to the
variable .init.data:spinning_secondaries
The function generic_secondary_common_init() references
the variable __initdata spinning_secondaries.
This is often because generic_secondary_common_init lacks a __initdata 
annotation or the annotation of spinning_secondaries is wrong.

WARNING: vmlinux.o(.text+0x93e4): Section mismatch in reference from the
function .start_secondary_prolog() to the
function .devinit.text:.start_secondary()
The function .start_secondary_prolog() references
the function __devinit .start_secondary().
This is often because .start_secondary_prolog lacks a __devinit 
annotation or the annotation of .start_secondary is wrong.

WARNING: vmlinux.o(.text+0x93f8): Section mismatch in reference from the
function .start_secondary_resume() to the
function .devinit.text:.start_secondary()
The function .start_secondary_resume() references
the function __devinit .start_secondary().
This is often because .start_secondary_resume lacks a __devinit 
annotation or the annotation of .start_secondary is wrong.

WARNING: vmlinux.o(.text+0x23034): Section mismatch in reference from
the function .early_setup_secondary() to the
function .cpuinit.text:.early_init_mmu_secondary()
The function .early_setup_secondary() references
the function __cpuinit .early_init_mmu_secondary().
This is often because .early_setup_secondary lacks a __cpuinit 
annotation or the annotation of .early_init_mmu_secondary is wrong.

WARNING: vmlinux.o(.text+0x349ac): Section mismatch in reference from
the function .prom_query_opal() to the function .init.text:.call_prom()
The function .prom_query_opal() references
the function __init .call_prom().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .call_prom is wrong.

WARNING: vmlinux.o(.text+0x349d4): Section mismatch in reference from
the function .prom_query_opal() to the function .init.text:.call_prom()
The function .prom_query_opal() references
the function __init .call_prom().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .call_prom is wrong.

WARNING: vmlinux.o(.text+0x349e4): Section mismatch in reference from
the function .prom_query_opal() to the
function .init.text:.prom_printf()
The function .prom_query_opal() references
the function __init .prom_printf().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: vmlinux.o(.text+0x34a40): Section mismatch in reference from
the function .prom_query_opal() to the
function .init.text:.prom_printf()
The function .prom_query_opal() references
the function __init .prom_printf().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: vmlinux.o(.text+0x34a64): Section mismatch in reference from
the function .prom_query_opal() to the
function .init.text:.prom_printf()
The function .prom_query_opal() references
the function __init .prom_printf().
This is often because .prom_query_opal lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: vmlinux.o(.text+0x34d98): Section mismatch in reference from
the function .prom_opal_takeover() to the
function .init.text:.prom_printf()
The function .prom_opal_takeover() references
the function __init .prom_printf().
This is often because .prom_opal_takeover lacks a __init 
annotation or the annotation of .prom_printf is wrong.

WARNING: vmlinux.o(.text+0x34d9c): Section mismatch in reference from
the function .prom_opal_takeover() to the
function .init.text:.prom_close_stdin()
The function .prom_opal_takeover() references
the function __init .prom_close_stdin().
This is often because .prom_opal_takeover lacks a __init 
annotation or the annotation of .prom_close_stdin is wrong.

WARNING: vmlinux.o(.text+0x3b024): Section mismatch in reference from
the function .kexec_prepare_cpus() to the
function .cpuinit.text:.cpu_up()
The function .kexec_prepare_cpus() references
the function __cpuinit .cpu_up().
This is often because .kexec_prepare_cpus lacks a __cpuinit 
annotation or the annotation of .cpu_up is wrong.

WARNING: vmlinux.o(.text+0x4c760): Section mismatch in reference from
the function .mark_reserved_regions_for_nid() to the
function .meminit.text:.early_pfn_to_nid()
The function .mark_reserved_regions_for_nid() references
the function __meminit .early_pfn_to_nid().
This is often because .mark_reserved_regions_for_nid lacks a __meminit 
annotation or the annotation of .early_pfn_to_nid is wrong.

WARNING: vmlinux.o(.text+0x4c780): Section mismatch in reference from
the function .mark_reserved_regions_for_nid() to the
function .init.text:.work_with_active_regions()
The function .mark_reserved_regions_for_nid() references
the function __init .work_with_active_regions().
This is often because .mark_reserved_regions_for_nid lacks a __init 
annotation or the annotation of .work_with_active_regions is wrong.

WARNING: vmlinux.o(.text+0x4c7d4): Section mismatch in reference from
the function .mark_reserved_regions_for_nid() to the
function .meminit.text:.early_pfn_to_nid()
The function .mark_reserved_regions_for_nid() references
the function __meminit .early_pfn_to_nid().
This is often because .mark_reserved_regions_for_nid lacks a __meminit 
annotation or the annotation of .early_pfn_to_nid is wrong.

WARNING: vmlinux.o(.text+0x4c7f0): Section mismatch in reference from
the function .mark_reserved_regions_for_nid() to the
function .init.text:.work_with_active_regions()
The function .mark_reserved_regions_for_nid() references
the function __init .work_with_active_regions().
This is often because .mark_reserved_regions_for_nid lacks a __init 
annotation or the annotation of .work_with_active_regions is wrong.

WARNING: vmlinux.o(.text+0x4c828): Section mismatch in reference from
the function .mark_reserved_regions_for_nid() to the
function .init.text:.reserve_bootmem_node()
The function .mark_reserved_regions_for_nid() references
the function __init .reserve_bootmem_node().
This is often because .mark_reserved_regions_for_nid lacks a __init 
annotation or the annotation of .reserve_bootmem_node is wrong.

WARNING: vmlinux.o(.text+0x5ba24): Section mismatch in reference from
the function .ics_rtas_init() to the
function .init.text:.xics_register_ics()
The function .ics_rtas_init() references
the function __init .xics_register_ics().
This is often because .ics_rtas_init lacks a __init 
annotation or the annotation of .xics_register_ics is wrong.

WARNING: vmlinux.o(.text+0x6e3ec): Section mismatch in reference from
the function .pci_dn_reconfig_notifier() to the
function .devinit.text:.update_dn_pci_info()
The function .pci_dn_reconfig_notifier() references
the function __devinit .update_dn_pci_info().
This is often because .pci_dn_reconfig_notifier lacks a __devinit 
annotation or the annotation of .update_dn_pci_info is wrong.

WARNING: vmlinux.o(.text+0x71f28): Section mismatch in reference from
the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up()
The function .dlpar_online_cpu() references
the function __cpuinit .cpu_up().
This is often because .dlpar_online_cpu lacks a __cpuinit 
annotation or the annotation of .cpu_up is wrong.

WARNING: vmlinux.o(.text+0x77248): Section mismatch in reference from
the function .pcibios_add_pci_devices() to the
function .devinit.text:.pcibios_setup_bus_devices()
The function .pcibios_add_pci_devices() references
the function __devinit .pcibios_setup_bus_devices().
This is often because .pcibios_add_pci_devices lacks a __devinit 
annotation or the annotation of .pcibios_setup_bus_devices is wrong.

WARNING: vmlinux.o(.text+0x77298): Section mismatch in reference from
the function .pcibios_add_pci_devices() to the
function .devinit.text:.pci_scan_bridge()
The function .pcibios_add_pci_devices() references
the function __devinit .pci_scan_bridge().
This is often because .pcibios_add_pci_devices lacks a __devinit 
annotation or the annotation of .pci_scan_bridge is wrong.

WARNING: vmlinux.o(.text+0x772d0): Section mismatch in reference from
the function .pcibios_add_pci_devices() to the
function .devinit.text:.of_rescan_bus()
The function .pcibios_add_pci_devices() references
the function __devinit .of_rescan_bus().
This is often because .pcibios_add_pci_devices lacks a __devinit 
annotation or the annotation of .of_rescan_bus is wrong.

WARNING: vmlinux.o(.text+0x3a3fe0): Section mismatch in reference from
the function .dlpar_remove_slot() to the
function .devinit.text:.vio_unregister_device()
The function .dlpar_remove_slot() references
the function __devinit .vio_unregister_device().
This is often because .dlpar_remove_slot lacks a __devinit 
annotation or the annotation of .vio_unregister_device is wrong.

WARNING: vmlinux.o(.text+0x3a40a8): Section mismatch in reference from
the function .dlpar_add_pci_slot() to the
function .devinit.text:.pcibios_map_io_space()
The function .dlpar_add_pci_slot() references
the function __devinit .pcibios_map_io_space().
This is often because .dlpar_add_pci_slot lacks a __devinit 
annotation or the annotation of .pcibios_map_io_space is wrong.

WARNING: vmlinux.o(.text+0x3a4148): Section mismatch in reference from
the function .dlpar_add_pci_slot() to the
function .devinit.text:.of_scan_pci_bridge()
The function .dlpar_add_pci_slot() references
the function __devinit .of_scan_pci_bridge().
This is often because .dlpar_add_pci_slot lacks a __devinit 
annotation or the annotation of .of_scan_pci_bridge is wrong.

WARNING: vmlinux.o(.text+0x3a4300): Section mismatch in reference from
the function .dlpar_add_slot() to the
function .devinit.text:.init_phb_dynamic()
The function .dlpar_add_slot() references
the function __devinit .init_phb_dynamic().
This is often because .dlpar_add_slot lacks a __devinit 
annotation or the annotation of .init_phb_dynamic is wrong.

WRAP    arch/powerpc/boot/zImage.pmac
WARNING: drivers/spi/spi-gpio.o(.devinit.text+0x8c): Section mismatch in
reference from the function .spi_gpio_probe() to the
function .init.text:.spi_gpio_alloc()
The function __devinit .spi_gpio_probe() references
a function __init .spi_gpio_alloc().
If .spi_gpio_alloc is only used by .spi_gpio_probe then
annotate .spi_gpio_alloc with a matching annotation.

WARNING: drivers/spi/spi-gpio.o(.devinit.text+0x210): Section mismatch
in reference from the function .spi_gpio_probe() to the
function .init.text:.spi_gpio_alloc()
The function __devinit .spi_gpio_probe() references
a function __init .spi_gpio_alloc().
If .spi_gpio_alloc is only used by .spi_gpio_probe then
annotate .spi_gpio_alloc with a matching annotation.

WARNING: drivers/spi/spi-gpio.o(.devinit.text+0x244): Section mismatch
in reference from the function .spi_gpio_probe() to the
function .init.text:.spi_gpio_alloc()
The function __devinit .spi_gpio_probe() references
a function __init .spi_gpio_alloc().
If .spi_gpio_alloc is only used by .spi_gpio_probe then
annotate .spi_gpio_alloc with a matching annotation.

Regards--
Subrata


