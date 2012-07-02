Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2GBMvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:51:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:51:13 -0400
X-AuditID: cbfee61b-b7f776d000002f3f-14-4ff1993f3104
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Takashi Iwai'" <tiwai@suse.de>, alsa-devel@alsa-project.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>, lrg@ti.com
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
 <4FEC3B70.5030902@metafoo.de> <s5hobo3zl79.wl%tiwai@suse.de>
 <20120628121816.GB21029@sirena.org.uk> <4FEC4E62.3020101@metafoo.de>
In-reply-to: <4FEC4E62.3020101@metafoo.de>
Subject: RE: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
Date: Mon, 02 Jul 2012 14:50:58 +0200
Organization: SPRC
Message-id: <02c301cd5851$572fd440$058f7cc0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1VKUX/1uLMvWdCRx6O9dE/eWzzgADJwXJw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQV37mR/9Dd4cNLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZk15tZyw4xFPxa+pT5gbG/5xdjJwcEgImEkvXtrJA2GISF+6t
	Z+ti5OIQEpjOKNGzfyELhDOLSWLbrytgVWwChhJdb7vYQGwRgQSJ7u5HTCBFzAKrGSWent7O
	CtFxilGiuXUnWBWngJbE8c4nQAkODmGBEIn9X6VAwiwCqhKP2rewg4T5BYQkJs5SAAnzCrhI
	zP29hRHCFpT4Mfke2F5moCnrdx5ngrDlJTavecsM0iohoC7x6K8uxDlGEl3L7jJDlIhI3G14
	zjqBUXgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB/gz6R2M
	qxosDjEKcDAq8fD+mPHRX4g1say4MvcQowQHs5II76lpQCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8TdYX/IUE0hNLUrNTUwtSi2CyTBycUg2MoTOMBc5KcL2tYORKi5tU5D+xvUpK4dr+6Q83
	9MzqNTtiPFFtnVnguter8j2EnZ4f6xSNKZ8toBcRky1rfUXmotLJMmsTPrGKDr6AY78a6z+V
	ak4wK7U6Un8uIVpNbP2f8BJnvfUJe0PV+b179U5GuDycNuHInZ8CznxsN2vSLi9S5Tg0d7ES
	S3FGoqEWc1FxIgBwZhbKbAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, June 28, 2012 2:30 PM Lars-Peter Clausen wrote:

> On 06/28/2012 02:18 PM, Mark Brown wrote:
> > On Thu, Jun 28, 2012 at 02:15:38PM +0200, Takashi Iwai wrote:
> >> Lars-Peter Clausen wrote:
> >
> >>> to the ALSA core. Now that there is a generic dma_mmap_writecombine it may
> >>> make sense to integrate this with snd_pcm_lib_default_mmap.
> >
> >> Agreed.
> >
> >> Also, it must be portable.  So far, only ARM has
> >> dma_mmap_writecombine(), thus the build on other arch would fail as
> >> is.
> >
> > Oh, dear - this means we don't actually have a generic API at all.  Is
> > there any effort being made to make this generally available?
> 
> Yes there is, and in fact in next/master there is generic
> dma_mmap_writecombine. I'm not quite sure how it behaves on non ARM archs
> though. But in theory it should fallback to a normal coherent mapping. Marek
> did a lot of work on this, I've put him on Cc.

On architectures which don't support DMA_ATTR_WRITECOMBINE attribute it falls
back to standard 'coherent' implementation, so it is equivalent to 
dma_mmap_coherent(). If architecture doesn't provide mmap callback, my patch
provides a so called 'generic' implementation based on virt_to_phys() macro.
Once this patch gets merged, I hope that each architecture will be reviewed 
if such implementation is correct. If not, some architectures might need to
provide their own implementations, but at least we can get the buffer-mmap
related hacks from the device drivers.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


