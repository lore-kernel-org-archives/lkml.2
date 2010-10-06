Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab0JFQCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:02:43 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:37572 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752114Ab0JFQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:02:42 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DsxWbu8VM1lJLrbnYQ7nJDga5lm5G6PlTVsT2dN.mAfyfyY
 m8LVgwSqtI_ucWNQFIh0LSwtvOFF9SboVrOVpdq07.u5mySXwAEUAPCdJs6c
 pqpsHeBGubASjFZDIPWhDzxBiOw0QMStwGDZztsp1bj9uDHZDRaW6DlPSbVT
 YcqRRoTIKVTPoYgIzbIaAsQOZ1qPPh_ELhuMIT3z2lmMC.xjieuOECuhup_N
 lt1DyDU6BiJuUi3HlGK0i4hOCJOptu3QYx42zts7fy4Sr3PbeQK2YPHIx9js
 63g--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Oct 2010 11:02:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: Fix memory hotplug with !NUMA
In-Reply-To: <1286373657-3894-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1010061101200.31538@router.home>
References: <1286373657-3894-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Pekka Enberg wrote:

> This patch fixes the following build breakage when memory hotplug is enabled on
> UMA configurations:

Hum? That works?

> diff --git a/mm/slub.c b/mm/slub.c
> index fe536d3..8fd5401 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2851,7 +2851,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
>  }
>  EXPORT_SYMBOL(kmem_cache_shrink);
>
> -#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
> +#if defined(CONFIG_MEMORY_HOTPLUG)
>  static int slab_mem_going_offline_callback(void *arg)
>  {
>  	struct kmem_cache *s;
>

Acked-by: Christoph Lameter <cl@linux.com>

