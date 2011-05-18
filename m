Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab1ERPM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:12:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1755 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894Ab1ERPMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:12:54 -0400
Subject: Re: [PATCH 0/4] ata: Logging message cleanups
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1302907496.git.joe@perches.com>
References: <cover.1302907496.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 08:12:53 -0700
Message-ID: <1305731573.1573.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 15:51 -0700, Joe Perches wrote:
> Neaten the code and shrink the text used about 5% or so
> for an x86 defconfig.
> 
> Joe Perches (4):
>   ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
>   ata: Convert ata_<foo>_printk(KERN_<LEVEL> to ata_<foo>_<level>(
>   ata: Add and use ata_print_version_once
>   ata: sata_via: Use dev_dbg

ping?

>  drivers/ata/acard-ahci.c      |   27 ++--
>  drivers/ata/ahci.c            |   53 +++---
>  drivers/ata/ata_generic.c     |    5 +-
>  drivers/ata/ata_piix.c        |   44 +++---
>  drivers/ata/libahci.c         |   95 +++++------
>  drivers/ata/libata-acpi.c     |   66 +++----
>  drivers/ata/libata-core.c     |  400 +++++++++++++++++++++++------------------
>  drivers/ata/libata-eh.c       |  143 +++++++--------
>  drivers/ata/libata-pmp.c      |  123 ++++++-------
>  drivers/ata/libata-scsi.c     |   22 +--
>  drivers/ata/libata-sff.c      |   52 +++---
>  drivers/ata/pata_ali.c        |    8 +-
>  drivers/ata/pata_amd.c        |    8 +-
>  drivers/ata/pata_artop.c      |    5 +-
>  drivers/ata/pata_atp867x.c    |   13 +-
>  drivers/ata/pata_bf54x.c      |    4 +-
>  drivers/ata/pata_cs5520.c     |    3 +-
>  drivers/ata/pata_efar.c       |    5 +-
>  drivers/ata/pata_hpt3x3.c     |    4 +-
>  drivers/ata/pata_icside.c     |    4 +-
>  drivers/ata/pata_it8213.c     |    5 +-
>  drivers/ata/pata_it821x.c     |   14 +-
>  drivers/ata/pata_ixp4xx_cf.c  |    4 +-
>  drivers/ata/pata_legacy.c     |    2 +-
>  drivers/ata/pata_macio.c      |   10 +-
>  drivers/ata/pata_mpiix.c      |    4 +-
>  drivers/ata/pata_netcell.c    |    5 +-
>  drivers/ata/pata_ns87410.c    |    2 +-
>  drivers/ata/pata_ns87415.c    |    5 +-
>  drivers/ata/pata_octeon_cf.c  |    8 +-
>  drivers/ata/pata_oldpiix.c    |    5 +-
>  drivers/ata/pata_opti.c       |    4 +-
>  drivers/ata/pata_optidma.c    |    4 +-
>  drivers/ata/pata_pcmcia.c     |    5 +-
>  drivers/ata/pata_pdc2027x.c   |    6 +-
>  drivers/ata/pata_platform.c   |    2 +-
>  drivers/ata/pata_radisys.c    |    5 +-
>  drivers/ata/pata_rdc.c        |    5 +-
>  drivers/ata/pata_rz1000.c     |    4 +-
>  drivers/ata/pata_samsung_cf.c |    2 +-
>  drivers/ata/pata_scc.c        |    8 +-
>  drivers/ata/pata_sch.c        |    5 +-
>  drivers/ata/pata_sil680.c     |    4 +-
>  drivers/ata/pata_sis.c        |    5 +-
>  drivers/ata/pata_sl82c105.c   |    6 +-
>  drivers/ata/pata_triflex.c    |    4 +-
>  drivers/ata/pata_via.c        |    8 +-
>  drivers/ata/pdc_adma.c        |   10 +-
>  drivers/ata/sata_fsl.c        |   43 ++---
>  drivers/ata/sata_inic162x.c   |   31 ++--
>  drivers/ata/sata_mv.c         |   94 +++++------
>  drivers/ata/sata_nv.c         |   79 ++++-----
>  drivers/ata/sata_promise.c    |    6 +-
>  drivers/ata/sata_qstor.c      |   13 +-
>  drivers/ata/sata_sil.c        |   21 +--
>  drivers/ata/sata_sil24.c      |   43 ++---
>  drivers/ata/sata_sis.c        |   26 ++--
>  drivers/ata/sata_svw.c        |    4 +-
>  drivers/ata/sata_sx4.c        |    4 +-
>  drivers/ata/sata_uli.c        |    4 +-
>  drivers/ata/sata_via.c        |   42 ++---
>  drivers/ata/sata_vsc.c        |    9 +-
>  include/linux/libata.h        |   68 ++++++--
>  63 files changed, 821 insertions(+), 901 deletions(-)
> 



