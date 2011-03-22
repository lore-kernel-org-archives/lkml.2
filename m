Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1CVPKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:10:43 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:43335 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754163Ab1CVPKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:10:41 -0400
X-Amavis-Alert: BAD HEADER SECTION, Improper folded header field made up
	entirely of whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n
	jycPrvgA\n\t\n R1goSzOnkp14Y[...]
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
In-Reply-To: <20110322145400.GC26952@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
	 <1300713067.8042.13.camel@thor.local> <20110321231835.GA20159@dumpdata.com>
	 <1300799599.3522.6.camel@thor.local>  <20110322145400.GC26952@dumpdata.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Mar 2011 16:10:22 +0100
Message-ID: <1300806622.3522.41.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-03-22 at 10:54 -0400, Konrad Rzeszutek Wilk wrote: 
> On Tue, Mar 22, 2011 at 02:13:19PM +0100, Michel Dänzer wrote:
> > On Mon, 2011-03-21 at 19:18 -0400, Konrad Rzeszutek Wilk wrote: 
> > > On Mon, Mar 21, 2011 at 02:11:07PM +0100, Michel Dänzer wrote:
> > > > On Fre, 2011-01-07 at 12:11 -0500, Konrad Rzeszutek Wilk wrote: 
> > > > > 
> > > > > 1) The 'NULL' when doing dma_alloc_coherent is unsightly. I was toying
> > > > > with modifying the TTM API to pass in 'struct device' or 'struct pci_device'
> > > > > but figured it would make first sense to get your guys input before heading that route.
> > > > 
> > > > It's worse than unsightly: It breaks TTM on PPC. See
> > > > arch/powerpc/include/asm/dma-mapping.h: get_dma_ops() returns NULL if
> > > > NULL is passed in for the device, and most of its callers BUG in that
> > > > case. The exception being dma_supported(), so a possible solution might
> > > > be to use that for checking if dma_alloc_coherent can be used.
> > > > 
> > > > Dave, please prevent this change from entering mainline before there's a
> > > > solution for this.
> > > 
> > > We do have a fix for it: 
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/ttm.pci-api.v5
> > > 
> > > Can you tell me if that works for you?
> > 
> > Yeah,
> > http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commitdiff;h=02bbfbab7dd6a107ea2f5d6e882631cd31c72eda and http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commitdiff;h=733301920082553b52ce4453493fe6abf6aa7d1a fix the problem.
> 
> Wheew. Good! What kind of hardware do you have that triggered this?
> When I implemented this patchset I hadn't thought about PPC b/c..well
> I didn't have the hardware nor did I think there were any ATI/Nvidia
> cards that worked with it. Can you give me an idea of type of hardware
> this is and where I could purchase it?

It's an Apple PowerBook with a Mobility Radeon 9700, to buy one new
you'd have to go back in time a couple of years first. ;) You should be
able to use more recent GPUs in a second-hand Apple G5 or YDL
PowerStation, which also have reasonably fast CPUs.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
